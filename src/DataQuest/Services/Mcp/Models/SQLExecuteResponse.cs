// ============================================================================
// DataQuest - SQL Execute Response Models (From mcp-mssql-server-repo)
// Purpose: SQL query execution result representation
// Source: D:\GitHub-Repos\mcp-mssql-server-repo\Models\SQLExecuteResponse.cs
// Adapted: December 5, 2025
// ============================================================================

using System;
using System.Collections.Generic;

namespace DataQuest.Services.Mcp.Models
{
    /// <summary>
    /// Represents a single row from query results
    /// </summary>
    public class QueryRow
    {
      /// <summary>
   /// Column values for this row (column name -> value)
        /// </summary>
        public Dictionary<string, object?> Values { get; set; } = new();
    }

 /// <summary>
    /// Response from SQL query execution
    /// </summary>
    public class SQLExecuteResponse
    {
        /// <summary>
  /// Whether query executed successfully
    /// </summary>
  public bool Success { get; set; }

        /// <summary>
     /// Original query that was executed
        /// </summary>
        public string? Query { get; set; }

      /// <summary>
        /// Number of rows returned
        /// </summary>
    public int RowCount { get; set; }

      /// <summary>
   /// Maximum row limit imposed
        /// </summary>
        public int MaxRowLimit { get; set; }

    /// <summary>
    /// Whether results were truncated due to max row limit
        /// </summary>
        public bool IsTruncated { get; set; }

     /// <summary>
    /// Rows returned from query
     /// </summary>
   public List<QueryRow> Rows { get; set; } = new();

    /// <summary>
        /// Column names in result set
        /// </summary>
      public List<string> Columns { get; set; } = new();

   /// <summary>
        /// Execution time in milliseconds
        /// </summary>
   public long ExecutionTimeMs { get; set; }

 /// <summary>
      /// Error message if execution failed
     /// </summary>
     public string? ErrorMessage { get; set; }

   /// <summary>
       /// Summary of results
    /// </summary>
        public string? Summary { get; set; }
  }
}
