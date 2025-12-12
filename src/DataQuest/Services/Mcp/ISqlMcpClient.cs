// ============================================================================
// DataQuest - SQL MCP Client Interface
// Purpose: Wrapper interface for SQL MCP server operations
// Date: December 5, 2025
// ============================================================================

using DataQuest.Services.Mcp.Models;
using System;
using System.Threading.Tasks;

namespace DataQuest.Services.Mcp
{
    /// <summary>
    /// Configuration options for SQL MCP operations
    /// </summary>
    public class SqlMcpExecutionOptions
    {
 /// <summary>
        /// Command timeout in seconds
        /// </summary>
        public int TimeoutSeconds { get; set; } = 30;

   /// <summary>
        /// Maximum number of rows to return
        /// </summary>
        public int MaxRows { get; set; } = 10000;

  /// <summary>
        /// Whether to batch execute statements
        /// </summary>
    public bool BatchExecution { get; set; } = true;
    }

    /// <summary>
    /// Result of SQL execution
    /// </summary>
    public class SqlExecutionResult
{
    /// <summary>
        /// Whether execution succeeded
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// Human-readable message
        /// </summary>
 public string Message { get; set; }

        /// <summary>
        /// Execution response (may be null if failed)
        /// </summary>
        public SQLExecuteResponse Response { get; set; }

        /// <summary>
    /// Error message if failed
        /// </summary>
        public string ErrorMessage { get; set; }

    /// <summary>
  /// Execution duration
        /// </summary>
        public TimeSpan Duration { get; set; }

        /// <summary>
        /// Create successful result
    /// </summary>
      public static SqlExecutionResult CreateSuccess(
   SQLExecuteResponse response, 
     TimeSpan duration,
      string message = "Execution successful")
        {
  return new SqlExecutionResult
  {
                Success = true,
     Message = message,
                Response = response,
  Duration = duration
            };
        }

     /// <summary>
        /// Create failed result
    /// </summary>
        public static SqlExecutionResult CreateFailure(
 string errorMessage, 
      TimeSpan duration,
 string message = "Execution failed")
        {
            return new SqlExecutionResult
      {
          Success = false,
    Message = message,
       ErrorMessage = errorMessage,
   Duration = duration
 };
        }
    }

    /// <summary>
    /// Interface for SQL MCP client operations
    /// 
    /// Wraps the MSSQLMCPServer for use in DatabaseManager
    /// Provides type-safe operations for database script execution
    /// </summary>
    public interface ISqlMcpClient
    {
        /// <summary>
        /// Executes a SQL script from file
    /// </summary>
        /// <param name="scriptPath">Path to SQL script file</param>
        /// <param name="options">Execution options</param>
        /// <returns>Execution result</returns>
        Task<SqlExecutionResult> ExecuteScriptAsync(
     string scriptPath,
     SqlMcpExecutionOptions options = null);

 /// <summary>
        /// Executes raw SQL query
        /// </summary>
      /// <param name="query">SQL query to execute</param>
      /// <param name="options">Execution options</param>
   /// <returns>Execution result with query results</returns>
        Task<SqlExecutionResult> ExecuteQueryAsync(
            string query,
      SqlMcpExecutionOptions options = null);

        /// <summary>
/// Checks if database exists
        /// </summary>
        /// <param name="databaseName">Name of database</param>
        /// <returns>True if database exists</returns>
     Task<bool> DatabaseExistsAsync(string databaseName);

  /// <summary>
        /// Gets database schema information
        /// </summary>
    /// <param name="databaseName">Name of database</param>
        /// <returns>Schema information</returns>
     Task<SchemaDescribeResponse> GetSchemaAsync(string databaseName);

        /// <summary>
        /// Gets table row count
    /// </summary>
        /// <param name="tableName">Name of table</param>
        /// <returns>Number of rows</returns>
        Task<int> GetTableRowCountAsync(string tableName);

        /// <summary>
        /// Executes script with batching (GO statement support)
        /// </summary>
     /// <param name="scriptPath">Path to SQL script</param>
     /// <param name="options">Execution options</param>
        /// <returns>Execution result</returns>
        Task<SqlExecutionResult> ExecuteBatchedScriptAsync(
            string scriptPath,
     SqlMcpExecutionOptions options = null);

      /// <summary>
        /// Gets current database connection status
        /// </summary>
  /// <returns>True if connected</returns>
        Task<bool> IsConnectedAsync();
    }
}
