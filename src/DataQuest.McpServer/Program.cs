using Microsoft.Extensions.Logging;

var shutdownRequested = false;

Console.CancelKeyPress += (_, e) =>
{
    e.Cancel = true;
    shutdownRequested = true;
};


var loggerFactory = LoggerFactory.Create(builder =>
{
    builder
        .AddConsole()
        .SetMinimumLevel(LogLevel.Debug);
});

var logger = loggerFactory.CreateLogger("DataQuest.McpServer");

logger.LogInformation("DataQuest MCP Server starting...");

while (!shutdownRequested)
{
    var line = Console.ReadLine();
    if (line == null)
    {
        logger.LogInformation("STDIN closed. MCP Server shutting down.");
        break;
    }

    logger.LogDebug("Received: {Line}", line);

    // Echo back for now (protocol comes next)
    Console.WriteLine(line);
}

