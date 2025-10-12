using EasyNetQ;
using CareConnect.Models.Messages;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNet.SignalR.Client;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using CareConnect.Subscriber;

public class Program
{
    public static async Task Main(string[] args)
    {
        Console.WriteLine("===========================================");
        Console.WriteLine("  RabbitMQ Notification Consumer Starting");
        Console.WriteLine("===========================================");
        Console.WriteLine();

        try
        {
            var host = CreateHostBuilder(args).Build();
            await host.RunAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Fatal error: {ex.Message}");
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureAppConfiguration((context, config) =>
            {
                config.SetBasePath(Directory.GetCurrentDirectory());
                config.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
                config.AddJsonFile(
                    $"appsettings.{context.HostingEnvironment.EnvironmentName}.json",
                    optional: true,
                    reloadOnChange: true);
                config.AddEnvironmentVariables();
                config.AddCommandLine(args);
            })
            .ConfigureServices((context, services) =>
            {
                services.AddHostedService<RabbitMqConsumerService>();

                services.AddSingleton<INotificationService, NotificationService>();

                Console.WriteLine("✓ Services registered");
            })
            .ConfigureLogging((context, logging) =>
            {
                logging.ClearProviders();
                logging.AddConsole();
                logging.AddDebug();

                logging.SetMinimumLevel(LogLevel.Information);

                Console.WriteLine("✓ Logging configured");
            })
            .UseConsoleLifetime();
}

