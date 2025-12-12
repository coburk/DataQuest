// ============================================================================
// DataQuest - Schema Describe Response Models (From mcp-mssql-server-repo)
// Purpose: Database schema introspection and metadata
// Source: D:\GitHub-Repos\mcp-mssql-server-repo\Models\SchemaDescribeResponse.cs
// Adapted: December 5, 2025
// ============================================================================

using System;
using System.Collections.Generic;

namespace DataQuest.Services.Mcp.Models
{
    /// <summary>
    /// Represents a database column in the schema description
    /// </summary>
    public class ColumnInfo
    {
        /// <summary>
 /// Column name
        /// </summary>
  public string? ColumnName { get; set; }

  /// <summary>
        /// Data type of the column (e.g., "VARCHAR", "INT")
     /// </summary>
        public string? DataType { get; set; }

      /// <summary>
      /// Maximum character length for string types, null for other types
/// </summary>
   public int? MaxLength { get; set; }

      /// <summary>
        /// Whether column allows null values
   /// </summary>
  public bool IsNullable { get; set; }

  /// <summary>
        /// Whether column is part of primary key
   /// </summary>
        public bool IsPrimaryKey { get; set; }

     /// <summary>
      /// Whether column is identity (auto-increment)
    /// </summary>
        public bool IsIdentity { get; set; }
    }

 /// <summary>
    /// Represents a foreign key relationship between tables
    /// </summary>
    public class ForeignKeyInfo
  {
   /// <summary>
/// Foreign key constraint name
        /// </summary>
        public string? ConstraintName { get; set; }

   /// <summary>
  /// Table containing the foreign key column
        /// </summary>
  public string? FromTable { get; set; }

   /// <summary>
        /// Column in FROM table that references another table
        /// </summary>
        public string? FromColumn { get; set; }

   /// <summary>
        /// Table being referenced
        /// </summary>
        public string? ToTable { get; set; }

  /// <summary>
        /// Primary key column in TO table being referenced
    /// </summary>
        public string? ToColumn { get; set; }
    }

    /// <summary>
    /// Represents a table in the database schema
    /// </summary>
    public class TableSchema
    {
        /// <summary>
        /// Table name
  /// </summary>
        public string? TableName { get; set; }

   /// <summary>
   /// Columns in the table
        /// </summary>
    public List<ColumnInfo> Columns { get; set; } = new();

      /// <summary>
 /// Foreign keys in the table
        /// </summary>
        public List<ForeignKeyInfo> ForeignKeys { get; set; } = new();

   /// <summary>
        /// Number of rows in the table
        /// </summary>
      public long RowCount { get; set; }
    }

   /// <summary>
    /// Response for schema introspection containing complete database schema
    /// </summary>
    public class SchemaDescribeResponse
    {
       /// <summary>
        /// Database name
    /// </summary>
        public string? DatabaseName { get; set; }

     /// <summary>
     /// Timestamp when schema was retrieved
        /// </summary>
 public DateTime RetrievedAt { get; set; }

  /// <summary>
   /// All tables in database with metadata
        /// </summary>
        public List<TableSchema> Tables { get; set; } = new();

      /// <summary>
   /// Summary message about schema retrieval
        /// </summary>
        public string? Summary { get; set; }
    }
}
