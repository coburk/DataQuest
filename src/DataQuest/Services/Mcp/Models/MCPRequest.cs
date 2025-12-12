// ============================================================================
// DataQuest - MCP Protocol Models (From mcp-mssql-server-repo)
// Purpose: MCP protocol request/response handling
// Source: D:\GitHub-Repos\mcp-mssql-server-repo\Models\MCPRequest.cs
// Adapted: December 5, 2025
// ============================================================================

using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace DataQuest.Services.Mcp.Models
{
    /// <summary>
/// MCP Protocol Request
    /// </summary>
    public class MCPRequest
    {
        [JsonPropertyName("jsonrpc")]
    public string Jsonrpc { get; set; } = "2.0";

        [JsonPropertyName("id")]
        public string? Id { get; set; }

[JsonPropertyName("method")]
        public string? Method { get; set; }

  [JsonPropertyName("params")]
      public Dictionary<string, object> Params { get; set; } = new();
    }

    /// <summary>
    /// MCP Protocol Response
    /// </summary>
    public class MCPResponse
    {
        [JsonPropertyName("jsonrpc")]
     public string Jsonrpc { get; set; } = "2.0";

        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("result")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
  public object? Result { get; set; }

  [JsonPropertyName("error")]
     [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public MCPError? Error { get; set; }
    }

    /// <summary>
    /// MCP Error Response
    /// </summary>
    public class MCPError
    {
   [JsonPropertyName("code")]
      public int Code { get; set; }

        [JsonPropertyName("message")]
        public string? Message { get; set; }

        [JsonPropertyName("data")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
      public object? Data { get; set; }
    }
}
