// ============================================================================
// DataQuest - Environment Validator Implementation
// Purpose: Validate database operations are only allowed in Development
// Date: December 5, 2025
// ============================================================================

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;

namespace DataQuest.Services.Database
{
    /// <summary>
    /// Validates that database management operations are only executed
    /// in Development environment
    /// </summary>
    public class EnvironmentValidator : IEnvironmentValidator
    {
      private readonly IConfiguration _configuration;
        private readonly ILogger<EnvironmentValidator> _logger;

        public EnvironmentValidator(
            IConfiguration configuration,
            ILogger<EnvironmentValidator> logger)
        {
          _configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Validates that current environment is Development
   /// </summary>
        /// <exception cref="InvalidOperationException">
        /// Thrown if environment is not Development
        /// </exception>
    public void ValidateDevelopmentEnvironment()
        {
 var environment = GetCurrentEnvironment();

            if (environment != "Development")
     {
           var message = $"Database management operations are only allowed in Development environment. " +
            $"Current environment: {environment}";

         _logger.LogError(message);
          _logger.LogWarning(
 "SECURITY: Attempted database management operation in {Environment} environment",
    environment);

    throw new InvalidOperationException(message);
   }

        _logger.LogDebug("Environment validation passed: Development environment confirmed");
        }

    /// <summary>
   /// Gets the current environment name
        /// </summary>
        public string GetCurrentEnvironment()
        {
   var environment = _configuration["ASPNETCORE_ENVIRONMENT"]
          ?? Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")
                ?? "Production"; // Default to Production for safety

         _logger.LogDebug("Current environment: {Environment}", environment);
  return environment;
        }

 /// <summary>
        /// Checks if current environment allows database management
        /// </summary>
  public bool IsEnvironmentAllowed()
   {
            return GetCurrentEnvironment() == "Development";
        }
}
}
