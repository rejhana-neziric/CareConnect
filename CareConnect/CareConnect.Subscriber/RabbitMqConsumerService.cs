using CareConnect.Models.Enums;
using CareConnect.Models.Messages;
using CareConnect.Services;
using EasyNetQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Subscriber
{
    public class RabbitMqConsumerService : BackgroundService
    {
        private readonly ILogger<RabbitMqConsumerService> _logger;

        private readonly IConfiguration _configuration;

        private readonly INotificationService _notificationService;

        private IBus? _bus;

        private bool _isConnected = false;

        private readonly string _subscriptionId = "appointment_notifications_subscription";

        public RabbitMqConsumerService(
            ILogger<RabbitMqConsumerService> logger,
            IConfiguration configuration,
            INotificationService notificationService)
        {
            _logger = logger;
            _configuration = configuration;
            _notificationService = notificationService;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("RabbitMQ Consumer Service starting...");

            await Task.Delay(2000, stoppingToken);

            try
            {
                await InitializeSignalRConnection(stoppingToken);
                await InitializeRabbitMQConnection(stoppingToken);
                await StartConsumingMessages(stoppingToken);

                while (!stoppingToken.IsCancellationRequested)
                {
                    await Task.Delay(1000, stoppingToken);

                    if (!_isConnected && _bus != null)
                    {
                        _logger.LogWarning("RabbitMQ connection lost. Attempting to reconnect...");
                        await InitializeRabbitMQConnection(stoppingToken);
                    }
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("RabbitMQ Consumer Service is stopping (cancellation requested)");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fatal error in RabbitMQ Consumer Service");

                await Task.Delay(5000, CancellationToken.None);
                throw;
            }
        }

        private async Task InitializeSignalRConnection(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Initializing SignalR connection...");

            try
            {
                await _notificationService.InitializeAsync();
                _logger.LogInformation("✓ SignalR connection established successfully");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to initialize SignalR connection");
                throw;
            }
        }

        private async Task InitializeRabbitMQConnection(CancellationToken stoppingToken)
        {
            var connectionString = _configuration.GetConnectionString("RabbitMQ");

            if (string.IsNullOrEmpty(connectionString))
            {
                connectionString = "host=localhost;port=5672;username=guest;password=guest;virtualHost=/";
                _logger.LogWarning("No RabbitMQ connection string found, using default: {ConnectionString}",
                    connectionString);
            }

            _logger.LogInformation("Connecting to RabbitMQ: {ConnectionString}",
                MaskPassword(connectionString));

            try
            {
                _bus = RabbitHutch.CreateBus(connectionString);
                _isConnected = true;
                _logger.LogInformation("✓ RabbitMQ connection established successfully");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to connect to RabbitMQ");
                _isConnected = false;
                throw;
            }

            await Task.CompletedTask;
        }

        private async Task StartConsumingMessages(CancellationToken stoppingToken)
        {
            if (_bus == null)
            {
                throw new InvalidOperationException("RabbitMQ bus is not initialized");
            }

            _logger.LogInformation("Starting to consume messages from RabbitMQ...");
            _logger.LogInformation("Subscription ID: {SubscriptionId}", _subscriptionId);

            try
            {
                await _bus.PubSub.SubscribeAsync<AppointmentNotificationMessage>(
                  _subscriptionId,
                  async message => await HandleAppointmentNotification(message),
                  configuration => configuration.WithTopic("appointment.*"));

                _logger.LogInformation("✓ Successfully subscribed to appointment notifications");
                _logger.LogInformation("Waiting for messages... (Press Ctrl+C to stop)");
                Console.WriteLine();
            }
            
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to subscribe to RabbitMQ messages");
                throw;
            }
        }

        private async Task HandleAppointmentNotification(AppointmentNotificationMessage message)
        {
            var startTime = DateTime.UtcNow;

            try
            {
                _logger.LogInformation(
                    "📨 Received notification - AppointmentId: {AppointmentId}, Status: {Status}, Client: {ClientId}, Employee: {EmployeeId}",
                    message.AppointmentId,
                    message.Status,
                    message.ClientId,
                    message.EmployeeId);

                await SendNotificationToRecipients(message);

                var duration = (DateTime.UtcNow - startTime).TotalMilliseconds;
                _logger.LogInformation(
                    "✓ Notification processed successfully in {Duration}ms - AppointmentId: {AppointmentId}",
                    duration,
                    message.AppointmentId);

                Console.WriteLine(); 
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "❌ Error handling notification - AppointmentId: {AppointmentId}",
                    message.AppointmentId);
            }
        }

        private async Task SendNotificationToRecipients(AppointmentNotificationMessage message)
        {
            var notificationTitle = GetNotificationTitle(message.Status);
            var notificationBody = GetNotificationBody(message);
            var notificationData = new Dictionary<string, object>
            {
                { "appointmentId", message.AppointmentId },
                { "status", message.Status.ToString() },
                { "appointmentDate", message.AppointmentDate.ToString("o") },
                { "serviceName", message.ServiceName }
            };

            _logger.LogDebug("Notification title: {Title}", notificationTitle);
            _logger.LogDebug("Notification body: {Body}", notificationBody);

            switch (message.Status)
            {
                case AppointmentStatus.Scheduled:
                    // Notify employee about new appointment
                    _logger.LogInformation("→ Sending notification to employee: {EmployeeId}", message.EmployeeId);
                    await _notificationService.SendNotificationAsync(
                        message.EmployeeId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;

                case AppointmentStatus.Confirmed:
                    // Notify client that appointment was confirmed
                    _logger.LogInformation("→ Sending notification to client: {ClientId}", message.ClientId);
                    await _notificationService.SendNotificationAsync(
                        message.ClientId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;
                    
                case AppointmentStatus.Rescheduled:
                    // Notify client that appointment was rejected
                    _logger.LogInformation("→ Sending notification to client: {ClientId}", message.ClientId);
                    await _notificationService.SendNotificationAsync(
                        message.ClientId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;

                case AppointmentStatus.Canceled:
                    // Notify both parties
                    _logger.LogInformation("→ Sending notifications to both client and employee");
                    await _notificationService.SendNotificationAsync(
                        message.ClientId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    await _notificationService.SendNotificationAsync(
                        message.EmployeeId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;

                case AppointmentStatus.RescheduleRequested:
                    // Notify client that appointment was rejected
                    _logger.LogInformation("→ Sending notification to client: {ClientId}", message.ClientId);
                    await _notificationService.SendNotificationAsync(
                        message.ClientId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;

                case AppointmentStatus.ReschedulePendingApproval:
                    // Notify client that appointment was rejected
                    _logger.LogInformation("→ Sending notification to employee: {EmployeeId}", message.EmployeeId);
                    await _notificationService.SendNotificationAsync(
                        message.EmployeeId,
                        notificationTitle,
                        notificationBody,
                        notificationData);
                    break;

                default:
                    _logger.LogWarning("Unknown appointment status: {Status}", message.Status);
                    break;
            }
        }

        private string GetNotificationTitle(AppointmentStatus status)
        {
            return status switch
            {
                AppointmentStatus.Scheduled => "New Appointment Request",
                AppointmentStatus.Confirmed => "Appointment Confirmed",
                AppointmentStatus.Rescheduled => "Appointment Rescheduled",
                AppointmentStatus.RescheduleRequested => "Reschedule for Appointment Requested",
                AppointmentStatus.ReschedulePendingApproval => "Approvement for Reschedule Requested",
                AppointmentStatus.Canceled => "Appointment Cancelled",
                AppointmentStatus.Completed => "Appointment Completed",
                _ => "Appointment Update"
            };
        }

        private string GetNotificationBody(AppointmentNotificationMessage message)
        {
            return message.Status switch
            {
                AppointmentStatus.Scheduled =>
                    $"New appointment request for {message.ServiceName} on {message.AppointmentDate:dd.MM.yyyy.}",
                AppointmentStatus.Confirmed =>
                    $"Your appointment for {message.ServiceName} on {message.AppointmentDate:dd. MM. yyyy.} has been confirmed.",
                AppointmentStatus.Rescheduled =>
                    $"Your appointment request for {message.ServiceName} on {message.AppointmentDate:dd. MM. yyyy.} has been successfully rescheduled.",
                AppointmentStatus.RescheduleRequested =>
                    $"A reschedule has been requested for your appointment for {message.ServiceName} on {message.AppointmentDate:dd.MM.yyyy}. Please review and confirm the new time.",
                AppointmentStatus.ReschedulePendingApproval =>
                    $"Your reschedule request for {message.ServiceName} on {message.AppointmentDate:dd.MM.yyyy} is pending approval.",
                AppointmentStatus.Canceled =>
                    $"The appointment for {message.ServiceName} on {message.AppointmentDate:dd. MM. yyyy.} has been cancelled.",
                AppointmentStatus.Completed =>
                    $"Your appointment for {message.ServiceName} is complete. Please leave a review!",
                _ => $"Your appointment for {message.ServiceName} status has been updated"
            };
        }

        private string MaskPassword(string connectionString)
        {
            if (connectionString.Contains("password=", StringComparison.OrdinalIgnoreCase))
            {
                var parts = connectionString.Split(';');
                for (int i = 0; i < parts.Length; i++)
                {
                    if (parts[i].StartsWith("password=", StringComparison.OrdinalIgnoreCase))
                    {
                        parts[i] = "password=****";
                    }
                }
                return string.Join(";", parts);
            }
            return connectionString;
        }

        public override async Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("RabbitMQ Consumer Service is stopping...");

            try
            {
                if (_bus != null)
                {
                    _bus.Dispose();
                    _logger.LogInformation("✓ RabbitMQ connection closed");
                }

                await _notificationService.DisconnectAsync();
                _logger.LogInformation("✓ SignalR connection closed");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during service shutdown");
            }

            await base.StopAsync(cancellationToken);
            _logger.LogInformation("RabbitMQ Consumer Service stopped");
        }

        public override void Dispose()
        {
            _bus?.Dispose();
            base.Dispose();
        }
    }
}
