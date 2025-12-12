// ============================================================================
// DataQuest - MCP Client Interface
//
// Purpose: Defines the transport-level contract for communicating with a local
//          Model Context Protocol (MCP) server via tool invocation.
//
// This interface represents a strict boundary:
// - The client does NOT execute SQL
// - The client does NOT understand database schema
// - The client ONLY sends tool requests and receives structured responses
//
// All database access is delegated to the MCP Server.
//
// Date: December 12, 2025
// ============================================================================


using System.Threading;
using System.Threading.Tasks;
using DataQuest.Services.Mcp.Models;

namespace DataQuest.Services.Mcp
{

    /// <summary>
    /// Transport-level interface for invoking MCP tools.
    ///
    /// Implementations are responsible only for:
    /// - Sending tool requests to the MCP server
    /// - Receiving and deserializing tool responses
    ///
    /// Implementations must NOT:
    /// - Execute SQL directly
    /// - Access the database
    /// - Contain domain or business logic
    /// </summary>
    

    public interface IMcpClient
    {
        /// Invokes a named MCP tool with structured parameters.
        /// The tool name and parameters must match the MCP Server's declared tool schema.

        /// <typeparam name="T">
        /// Expected response payload type returned by the MCP tool.
        /// </typeparam>
        /// <param name="toolName">
        /// The MCP tool identifier (e.g. "execute_sql", "describe_schema").
        /// </param>
        /// <param name="parameters">
        /// Tool-specific arguments serialized and sent to the MCP server.
        /// </param>
        /// <param name="cancellationToken">
        /// Token used to cancel the request or terminate a stalled MCP call.
        /// </param>
     


        Task<McpToolResponse<T>> CallToolAsync<T>(
            string toolName,
            object parameters,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Performs a lightweight connectivity check against the MCP server.
        /// Used to verify that the MCP process is running and responsive.
        /// </summary>


        Task<bool> PingAsync(CancellationToken cancellationToken = default);
    }
}
