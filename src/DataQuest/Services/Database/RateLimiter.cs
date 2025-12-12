// ============================================================================
// DataQuest - Rate Limiter Implementation
// Purpose: Prevent accidental rapid deletion of database
// Date: December 5, 2025
// ============================================================================

using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DataQuest.Services.Database
{
    /// <summary>
    /// Implements rate limiting for destructive database operations
/// 
    /// Prevents accidental repeated deletes by enforcing a 5-minute
    /// window between delete operations
    /// </summary>
    public class RateLimiter : IRateLimiter
    {
  private readonly ILogger<RateLimiter> _logger;
        private readonly Dictionary<string, DateTime> _lastOperationTimes = new();
   private const int DeleteWindowMinutes = 5;

   public RateLimiter(ILogger<RateLimiter> logger)
        {
 _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

    /// <summary>
      /// Checks if an operation is allowed (not rate limited)
        /// </summary>
        public bool IsOperationAllowed(string operationName)
        {
    if (string.IsNullOrWhiteSpace(operationName))
            {
  _logger.LogWarning("Rate limiter check with null operation name");
               return true; // Allow if no operation name (shouldn't happen)
         }

     if (!_lastOperationTimes.ContainsKey(operationName))
  {
         _logger.LogDebug("Operation {Operation} has no history, allowing", operationName);
    return true; // First time, always allow
           }

         var lastTime = _lastOperationTimes[operationName];
      var timeSinceLastOperation = DateTime.UtcNow - lastTime;
    var isAllowed = timeSinceLastOperation.TotalMinutes >= DeleteWindowMinutes;

   if (!isAllowed)
      {
     var minutesRemaining = DeleteWindowMinutes - timeSinceLastOperation.TotalMinutes;
          _logger.LogWarning(
      "Operation {Operation} rate limited. {Minutes:F1} minutes remaining",
    operationName,
     minutesRemaining);
           }

         return isAllowed;
      }

        /// <summary>
        /// Records that an operation was performed (updates last operation time)
        /// </summary>
   public Task RecordOperationAsync(string operationName)
        {
     if (string.IsNullOrWhiteSpace(operationName))
           {
         return Task.CompletedTask;
          }

         _lastOperationTimes[operationName] = DateTime.UtcNow;
  _logger.LogInformation(
     "Operation {Operation} recorded at {Timestamp:O}",
         operationName,
     DateTime.UtcNow);

return Task.CompletedTask;
      }

        /// <summary>
      /// Gets time remaining before operation is allowed
        /// </summary>
       public TimeSpan? GetTimeUntilAllowed(string operationName)
      {
   if (string.IsNullOrWhiteSpace(operationName))
         {
   return null;
          }

         if (!_lastOperationTimes.ContainsKey(operationName))
  {
    return null; // No history, allowed now
     }

  var lastTime = _lastOperationTimes[operationName];
    var timeSinceLastOperation = DateTime.UtcNow - lastTime;
          var windowInMinutes = TimeSpan.FromMinutes(DeleteWindowMinutes);

       if (timeSinceLastOperation >= windowInMinutes)
  {
  return null; // Already allowed
           }

   var timeRemaining = windowInMinutes - timeSinceLastOperation;
_logger.LogDebug(
    "Time remaining for {Operation}: {TimeRemaining:hh\\:mm\\:ss}",
    operationName,
 timeRemaining);

   return timeRemaining;
  }
    }
}
