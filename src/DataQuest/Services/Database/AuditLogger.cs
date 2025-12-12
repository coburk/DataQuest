// ============================================================================
// DataQuest - Audit Logger Implementation
// Purpose: Log all database operations for compliance and debugging
// Date: December 5, 2025
// ============================================================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DataQuest.Services.Database
{
    /// <summary>
    /// Implements audit logging for database operations
    /// 
    /// Maintains immutable log of all database operations for
    /// compliance verification and troubleshooting
    /// </summary>
    public class AuditLogger : IAuditLogger
    {
 private readonly ILogger<AuditLogger> _logger;
        private readonly List<AuditLogEntry> _auditLog = new();

 public class AuditLogEntry
        {
         public Guid Id { get; set; } = Guid.NewGuid();
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
 public string OperationType { get; set; }
            public string UserId { get; set; }
         public string Environment { get; set; }
          public bool Success { get; set; }
   public TimeSpan? Duration { get; set; }
        public string Details { get; set; }
       public string ErrorMessage { get; set; }
        }

     public AuditLogger(ILogger<AuditLogger> logger)
  {
         _logger = logger ?? throw new ArgumentNullException(nameof(logger));
       }

      /// <summary>
     /// Logs a database operation
        /// </summary>
   public Task LogDatabaseOperationAsync(
            string operationType,
            bool success,
     TimeSpan duration,
   Dictionary<string, object> details = null)
        {
     var entry = new AuditLogEntry
          {
      OperationType = operationType,
         Success = success,
      Duration = duration,
            Details = FormatDetails(details),
      Environment = GetEnvironment(),
            UserId = GetCurrentUser()
    };

    _auditLog.Add(entry);

   _logger.LogInformation(
    "Database operation logged: {Operation} - Success: {Success}, Duration: {Duration:hh\\:mm\\:ss\\.fff}",
    operationType,
         success,
      duration);

  if (!success && details?.ContainsKey("error") == true)
 {
      _logger.LogError(
 "Database operation failed: {Operation} - Error: {Error}",
      operationType,
        details["error"]);
      }

        return Task.CompletedTask;
 }

  /// <summary>
        /// Logs an access attempt to database endpoints
        /// </summary>
public Task LogAccessAttemptAsync(
       string endpoint,
        string userId,
           bool allowed)
  {
       _logger.LogInformation(
       "Access attempt: Endpoint: {Endpoint}, User: {User}, Allowed: {Allowed}",
 endpoint,
           userId ?? "Anonymous",
       allowed);

   if (!allowed)
    {
           _logger.LogWarning(
  "SECURITY: Unauthorized access attempt to {Endpoint} by {User}",
        endpoint,
      userId ?? "Anonymous");
         }

        return Task.CompletedTask;
       }

    /// <summary>
  /// Retrieves audit log entries
     /// </summary>
  public Task<IEnumerable<Dictionary<string, object>>> GetAuditLogAsync(
     string operationType,
      int limit = 100)
{
          var query = _auditLog.AsEnumerable();

  if (!string.IsNullOrWhiteSpace(operationType))
      {
      query = query.Where(e =>
          e.OperationType.Equals(operationType, StringComparison.OrdinalIgnoreCase));
    }

      var results = query
  .OrderByDescending(e => e.Timestamp)
   .Take(limit)
  .Select(e => new Dictionary<string, object>
        {
    { "Id", e.Id },
     { "Timestamp", e.Timestamp },
          { "OperationType", e.OperationType },
      { "UserId", e.UserId },
 { "Environment", e.Environment },
 { "Success", e.Success },
         { "Duration", e.Duration?.ToString(@"hh\:mm\:ss\.fff") ?? "N/A" },
              { "Details", e.Details },
       { "ErrorMessage", e.ErrorMessage }
             })
    .ToList();

    _logger.LogDebug(
         "Audit log query: OperationType={OperationType}, ResultCount={Count}",
         operationType ?? "All",
     results.Count);

     return Task.FromResult<IEnumerable<Dictionary<string, object>>>(results);
    }

      /// <summary>
        /// Gets current environment (injected or from environment variable)
       /// </summary>
        private string GetEnvironment()
      {
  return Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown";
       }

        /// <summary>
        /// Gets current user (to be populated from HttpContext in actual implementation)
       /// </summary>
     private string GetCurrentUser()
    {
     return System.Security.Principal.WindowsIdentity.GetCurrent()?.Name ?? "SystemService";
        }

      /// <summary>
     /// Formats details dictionary as string
        /// </summary>
       private string FormatDetails(Dictionary<string, object> details)
  {
        if (details == null || details.Count == 0)
            {
    return null;
     }

    return string.Join("; ", details.Select(kvp => $"{kvp.Key}={kvp.Value}"));
      }
  }
}
