// ============================================================================
// DataQuest - Database Management Service Interfaces
// Purpose: Define contracts for database management with MCP integration
// Date: December 5, 2025
// ============================================================================

using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DataQuest.Services.Database
{
    /// <summary>
    /// Result of a database operation
    /// </summary>
    public class DatabaseOperationResult
    {
      /// <summary>
     /// Whether the operation succeeded
  /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// Human-readable message about the operation
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Duration of the operation
        /// </summary>
 public TimeSpan Duration { get; set; }

  /// <summary>
        /// Record counts per table (if applicable)
  /// </summary>
        public Dictionary<string, int> RecordCounts { get; set; } = new();

        /// <summary>
      /// Error message (if operation failed)
        /// </summary>
        public string Error { get; set; }
    }

    /// <summary>
    /// Current database status information
    /// </summary>
    public class DatabaseStatus
    {
      /// <summary>
        /// Whether database is initialized
        /// </summary>
        public bool IsInitialized { get; set; }

        /// <summary>
   /// Number of tables in database
        /// </summary>
        public int TableCount { get; set; }

      /// <summary>
 /// Record count per table
 /// </summary>
        public Dictionary<string, int> RecordCounts { get; set; } = new();

        /// <summary>
        /// Timestamp of last database operation
        /// </summary>
        public DateTime? LastOperation { get; set; }

        /// <summary>
        /// Type of last operation (Create, Delete, Recreate, Seed, Migrate)
        /// </summary>
        public string LastOperationType { get; set; }

/// <summary>
     /// Number of records in Tier 1 cases
        /// </summary>
   public int Tier1CaseRecords { get; set; }
    }

    /// <summary>
    /// Defines database management operations for DataQuest
    /// 
    /// IMPORTANT: All operations are Development-environment ONLY
    /// Production environments cannot use these methods.
    /// 
    /// Architecture: This service wraps SQL MCP infrastructure for
    /// standardized database operations, adding application-level
    /// safeguards (environment validation, rate limiting, etc.)
    /// </summary>
    public interface IDatabaseManager
    {
     /// <summary>
        /// Creates the DataQuest database with initial schema
    /// 
   /// Executes: V001_InitialSchema.sql
      /// Creates: 14 tables with all constraints and indexes
        /// Environment: Development ONLY
        /// Time: ~4-5 seconds
/// </summary>
        /// <returns>Operation result with table counts</returns>
        /// <exception cref="InvalidOperationException">If not in Development environment</exception>
        Task<DatabaseOperationResult> CreateDatabaseAsync();

 /// <summary>
    /// Deletes the DataQuest database (Development environment only)
        /// 
        /// DESTRUCTIVE: This removes all tables and data
        /// Requires: Explicit confirmation token
    /// Rate Limited: Cannot delete twice within 5 minutes
        /// Logged: All deletion attempts are audited
        /// Environment: Development ONLY
      /// Time: ~2 seconds
        /// </summary>
        /// <param name="confirmationToken">
        /// Confirmation token from initial request proving user intent.
        /// Token expires after 5 minutes and is single-use.
        /// </param>
        /// <returns>Operation result confirming deletion</returns>
        /// <exception cref="InvalidOperationException">If not in Development environment</exception>
        /// <exception cref="ArgumentException">If confirmation token invalid/expired</exception>
        /// <exception cref="InvalidOperationException">If rate limited (too recent delete)</exception>
        Task<DatabaseOperationResult> DeleteDatabaseAsync(string confirmationToken);

        /// <summary>
     /// Recreates the entire database (Delete + Create + Seed)
        /// 
        /// Atomic: All-or-nothing operation
        /// Requires: Explicit confirmation token
/// Result: Fresh database with seed data
  /// Environment: Development ONLY
        /// Time: ~8-10 seconds
        /// </summary>
      /// <param name="confirmationToken">Confirmation token proving user intent</param>
        /// <returns>Operation result with new data counts</returns>
     /// <exception cref="InvalidOperationException">If not in Development environment</exception>
   /// <exception cref="ArgumentException">If confirmation token invalid/expired</exception>
      Task<DatabaseOperationResult> RecreateDatabaseAsync(string confirmationToken);

        /// <summary>
        /// Populates database with seed data for Tier 1 cases
   /// 
        /// Executes: V001_SeedData_Tier1.sql
        /// Inserts: Case 1.1 & 1.2 with all supporting data
        /// Records: ~78 total records across all tables
        /// Time: ~3 seconds
        /// </summary>
     /// <returns>Operation result with record counts</returns>
        /// <exception cref="InvalidOperationException">If tables don't exist</exception>
Task<DatabaseOperationResult> SeedDataAsync();

        /// <summary>
     /// Checks if database is initialized
        /// </summary>
     /// <returns>True if all required tables exist, false otherwise</returns>
        Task<bool> IsInitializedAsync();

      /// <summary>
  /// Gets current database status
  /// </summary>
    /// <returns>DatabaseStatus with table and record counts</returns>
    Task<DatabaseStatus> GetStatusAsync();

        /// <summary>
    /// Applies a migration script
        /// 
 /// Uses SQL MCP infrastructure for migration execution
        /// Tracks migration history
        /// Supports rollback on failure
        /// </summary>
      /// <param name="migrationPath">Path to migration script file</param>
     /// <param name="versionNumber">Version number of migration</param>
        /// <returns>Operation result</returns>
        /// <exception cref="FileNotFoundException">If migration script not found</exception>
        /// <exception cref="InvalidOperationException">If migration already applied</exception>
      Task<DatabaseOperationResult> ApplyMigrationsAsync(
            string migrationPath,
            int versionNumber);

    /// <summary>
        /// Generates a confirmation token for destructive operations
        /// 
        /// Token is required to confirm delete/recreate operations
    /// Prevents accidental database deletion
   /// </summary>
        /// <returns>Confirmation token (valid for 5 minutes)</returns>
      string GenerateConfirmationToken();

     /// <summary>
        /// Validates a confirmation token
        /// </summary>
        /// <param name="token">Token to validate</param>
        /// <returns>True if valid and not expired, false otherwise</returns>
bool ValidateConfirmationToken(string token);
    }

    /// <summary>
    /// Validates database operations against environment constraints
    /// </summary>
    public interface IEnvironmentValidator
    {
 /// <summary>
        /// Validates that current environment allows database operations
        /// </summary>
      /// <exception cref="InvalidOperationException">If not Development environment</exception>
        void ValidateDevelopmentEnvironment();

    /// <summary>
        /// Gets current environment name
 /// </summary>
        string GetCurrentEnvironment();

        /// <summary>
        /// Checks if environment allows database management
  /// </summary>
        bool IsEnvironmentAllowed();
    }

    /// <summary>
  /// Manages rate limiting for destructive database operations
    /// </summary>
    public interface IRateLimiter
    {
     /// <summary>
        /// Checks if a destructive operation is allowed
        /// </summary>
        /// <param name="operationName">Name of operation (e.g., "DatabaseDelete")</param>
        /// <returns>True if operation allowed, false if rate limited</returns>
        bool IsOperationAllowed(string operationName);

 /// <summary>
      /// Records that an operation was performed
  /// </summary>
        /// <param name="operationName">Name of operation performed</param>
        Task RecordOperationAsync(string operationName);

   /// <summary>
        /// Gets time remaining before operation is allowed
        /// </summary>
        /// <param name="operationName">Name of operation</param>
      /// <returns>TimeSpan until operation is allowed, or null if allowed now</returns>
        TimeSpan? GetTimeUntilAllowed(string operationName);
    }

    /// <summary>
    /// Logs database operations for audit trail
    /// 
    /// Integrates with SQL MCP logging infrastructure
    /// Creates audit records for compliance
    /// </summary>
    public interface IAuditLogger
    {
     /// <summary>
/// Logs a database operation
        /// </summary>
        /// <param name="operationType">Type of operation (Create, Delete, Recreate, Seed, Migrate)</param>
        /// <param name="success">Whether operation succeeded</param>
   /// <param name="duration">Duration of operation</param>
        /// <param name="details">Additional operation details</param>
     Task LogDatabaseOperationAsync(
            string operationType,
bool success,
 TimeSpan duration,
    Dictionary<string, object> details = null);

 /// <summary>
        /// Logs an access attempt
        /// </summary>
        /// <param name="endpoint">API endpoint accessed</param>
        /// <param name="userId">User attempting access</param>
        /// <param name="allowed">Whether access was allowed</param>
        Task LogAccessAttemptAsync(
    string endpoint,
   string userId,
            bool allowed);

        /// <summary>
    /// Gets audit log for specified operation
   /// </summary>
      /// <param name="operationType">Type of operation to query</param>
        /// <param name="limit">Maximum number of records to return</param>
        Task<IEnumerable<Dictionary<string, object>>> GetAuditLogAsync(
    string operationType,
            int limit = 100);
    }
}
