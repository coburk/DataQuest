// ============================================================================
// DataQuest - MCP Transport Client
// Purpose:
//   App-side JSON-RPC client responsible for communicating with the
//   DataQuest MCP Server over stdin/stdout.
// 
//   This component performs NO direct database access.
//   All SQL execution occurs exclusively within the MCP Server.
// 
// Date: December 12, 2025
// ============================================================================


using System;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using DataQuest.Services.Mcp.Models;
using Microsoft.Extensions.Logging;

namespace DataQuest.Services.Mcp
{
    public sealed class McpTransportClient : IMcpClient, IDisposable
    {
        private readonly ILogger<McpTransportClient> logger;
        private readonly string serverExePath;

        private Process? process;
        private StreamWriter? stdin;
        private StreamReader? stdout;

        private int nextId = 1;
        private readonly object idLock = new object();

        private static readonly JsonSerializerOptions JsonOptions = new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };

        public McpTransportClient(string serverExePath, ILogger<McpTransportClient> logger)
        {
            this.serverExePath = serverExePath ?? throw new ArgumentNullException(nameof(serverExePath));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<bool> PingAsync(CancellationToken cancellationToken = default)
        {
            var response = await CallToolAsync<object>(
                toolName: "ping",
                parameters: new { },
                cancellationToken: cancellationToken);

            return response.Success;
        }

        public async Task<McpToolResponse<T>> CallToolAsync<T>(
            string toolName,
            object parameters,
            CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(toolName))
            {
                throw new ArgumentException("Tool name cannot be empty.", nameof(toolName));
            }

            await EnsureStartedAsync(cancellationToken);

            var id = GetNextId();

            var request = new JsonRpcRequest
            {
                Id = id,
                Method = "tools.call",
                Params = new
                {
                    name = toolName,
                    arguments = parameters
                }
            };

            var requestJson = JsonSerializer.Serialize(request, JsonOptions);

            logger.LogDebug("MCP -> {Request}", requestJson);

            await stdin!.WriteLineAsync(requestJson.AsMemory(), cancellationToken);
            await stdin.FlushAsync();

            var responseLine = await ReadLineAsync(stdout!, cancellationToken);
            if (responseLine == null)
            {
                return new McpToolResponse<T>
                {
                    Success = false,
                    ErrorMessage = "MCP server returned no response (stdout closed)."
                };
            }

            logger.LogDebug("MCP <- {Response}", responseLine);

            JsonRpcResponse<JsonElement> envelope;
            try
            {
                envelope = JsonSerializer.Deserialize<JsonRpcResponse<JsonElement>>(responseLine, JsonOptions)
                    ?? throw new InvalidOperationException("Failed to deserialize MCP response.");
            }
            catch (Exception ex)
            {
                return new McpToolResponse<T>
                {
                    Success = false,
                    ErrorMessage = $"Invalid MCP response JSON: {ex.Message}"
                };
            }

            if (envelope.Error != null)
            {
                return new McpToolResponse<T>
                {
                    Success = false,
                    ErrorMessage = $"MCP error {envelope.Error.Code}: {envelope.Error.Message}"
                };
            }

            if (envelope.Result.ValueKind == JsonValueKind.Undefined || envelope.Result.ValueKind == JsonValueKind.Null)
            {
                return new McpToolResponse<T> { Success = true, Data = default };
            }

            try
            {
                var typed = envelope.Result.Deserialize<T>(JsonOptions);
                return new McpToolResponse<T> { Success = true, Data = typed };
            }
            catch (Exception ex)
            {
                return new McpToolResponse<T>
                {
                    Success = false,
                    ErrorMessage = $"Failed to parse MCP result payload: {ex.Message}"
                };
            }
        }

        private async Task EnsureStartedAsync(CancellationToken cancellationToken)
        {
            if (process != null && !process.HasExited && stdin != null && stdout != null)
            {
                return;
            }

            var startInfo = new ProcessStartInfo
            {
                FileName = serverExePath,
                Arguments = "",
                UseShellExecute = false,
                RedirectStandardInput = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true
            };

            process = new Process { StartInfo = startInfo, EnableRaisingEvents = true };

            process.ErrorDataReceived += (_, e) =>
            {
                if (!string.IsNullOrWhiteSpace(e.Data))
                {
                    logger.LogWarning("MCP STDERR: {Line}", e.Data);
                }
            };

            if (!process.Start())
            {
                throw new InvalidOperationException("Failed to start MCP server process.");
            }

            process.BeginErrorReadLine();

            stdin = process.StandardInput;
            stdout = process.StandardOutput;

            await Task.Delay(50, cancellationToken);
        }

        private int GetNextId()
        {
            lock (idLock)
            {
                return nextId++;
            }
        }

        private static async Task<string?> ReadLineAsync(StreamReader reader, CancellationToken cancellationToken)
        {
            var sb = new StringBuilder();
            while (true)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var ch = new char[1];
                var read = await reader.ReadAsync(ch, 0, 1);
                if (read == 0)
                {
                    return sb.Length == 0 ? null : sb.ToString();
                }

                if (ch[0] == '\n')
                {
                    break;
                }

                if (ch[0] != '\r')
                {
                    sb.Append(ch[0]);
                }
            }

            return sb.ToString();
        }

        public void Dispose()
        {
            try
            {
                stdin?.Dispose();
                stdout?.Dispose();

                if (process != null && !process.HasExited)
                {
                    process.Kill(entireProcessTree: true);
                }

                process?.Dispose();
            }
            catch
            {
                // No throw on dispose
            }
        }
    }
}

