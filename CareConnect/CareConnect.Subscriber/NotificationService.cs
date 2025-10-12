using CareConnect.Models.Messages;
using CareConnect.Models.Responses;
using EasyNetQ;
using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Subscriber
{
    public class NotificationService : INotificationService, IAsyncDisposable
    {
        private readonly ILogger<NotificationService> _logger;

        private readonly IConfiguration _configuration;

        private HubConnection? _hubConnection;

        private readonly string _hubUrl;

        private readonly int _maxRetryAttempts = 5;

        private readonly int _retryDelaySeconds = 5;

        public bool IsConnected =>
            _hubConnection?.State == HubConnectionState.Connected;

        public NotificationService(
            ILogger<NotificationService> logger,
            IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
            _hubUrl = configuration["SignalR:HubUrl"]
                ?? "https://localhost:7000/notificationHub";
        }

        public async Task InitializeAsync()
        {
            _logger.LogInformation("Initializing SignalR connection to: {HubUrl}", _hubUrl);

            var retryCount = 0;

            while (retryCount < _maxRetryAttempts)
            {
                try
                {
                    _hubConnection = new HubConnectionBuilder()
                        .WithUrl(_hubUrl, options =>
                        {
                            
                        })
                        .WithAutomaticReconnect(new[]
                        {
                            TimeSpan.Zero,
                            TimeSpan.FromSeconds(2),
                            TimeSpan.FromSeconds(5),
                            TimeSpan.FromSeconds(10),
                            TimeSpan.FromSeconds(30)
                        })
                        .Build();

                    _hubConnection.Reconnecting += OnReconnecting;
                    _hubConnection.Reconnected += OnReconnected;
                    _hubConnection.Closed += OnClosed;

                    await _hubConnection.StartAsync();

                    _logger.LogInformation("✓ Successfully connected to SignalR Hub");
                    _logger.LogInformation("Connection ID: {ConnectionId}", _hubConnection.ConnectionId);
                    _logger.LogInformation("Connection State: {State}", _hubConnection.State);

                    return;
                }
                catch (Exception ex)
                {
                    retryCount++;
                    _logger.LogError(ex,
                        "Failed to connect to SignalR Hub (Attempt {Attempt}/{MaxAttempts})",
                        retryCount,
                        _maxRetryAttempts);

                    if (retryCount < _maxRetryAttempts)
                    {
                        var delay = _retryDelaySeconds * retryCount;
                        _logger.LogInformation("Retrying in {Delay} seconds...", delay);
                        await Task.Delay(TimeSpan.FromSeconds(delay));
                    }
                    else
                    {
                        _logger.LogCritical("Failed to connect to SignalR after {MaxAttempts} attempts",
                            _maxRetryAttempts);
                        throw;
                    }
                }
            }
        }

        public async Task SendNotificationAsync(
            int userId,
            string title,
            string body,
            Dictionary<string, object>? data = null)
        {
            if (userId == null)
            {
                _logger.LogWarning("Cannot send notification: userId is null or empty");
                return;
            }

            if (_hubConnection?.State != HubConnectionState.Connected)
            {
                _logger.LogWarning("SignalR not connected (State: {State}). Attempting to reconnect...",
                    _hubConnection?.State);

                try
                {
                    await InitializeAsync();
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to reconnect to SignalR");
                    throw;
                }
            }

            try
            {
                var notification = new Notification
                {
                    Title = title,
                    Body = body,
                    Type = "appointment_update",
                    Data = data ?? new Dictionary<string, object>()
                };

                _logger.LogInformation(
                    "Invoking SendNotificationToUser for userId: {UserId}, Title: {Title}",
                    userId,
                    title);

                await _hubConnection!.InvokeAsync(
                    "SendNotificationToUser", 
                    userId,
                    notification);

                _logger.LogInformation(
                    "✓ Successfully invoked SendNotificationToUser for user {UserId}",
                    userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "❌ Failed to send notification to user {UserId}: {Title}",
                    userId,
                    title);
                throw;
            }
        }

        private Task OnReconnecting(Exception? error)
        {
            _logger.LogWarning("SignalR connection lost. Reconnecting... Error: {Error}",
                error?.Message ?? "Unknown");
            return Task.CompletedTask;
        }

        private Task OnReconnected(string? connectionId)
        {
            _logger.LogInformation("✓ SignalR reconnected successfully. ConnectionId: {ConnectionId}",
                connectionId);
            return Task.CompletedTask;
        }

        private Task OnClosed(Exception? error)
        {
            if (error != null)
            {
                _logger.LogError(error, "❌ SignalR connection closed with error");
            }
            else
            {
                _logger.LogInformation("SignalR connection closed");
            }
            return Task.CompletedTask;
        }

        public async Task DisconnectAsync()
        {
            if (_hubConnection != null)
            {
                try
                {
                    await _hubConnection.StopAsync();
                    await _hubConnection.DisposeAsync();
                    _logger.LogInformation("✓ Disconnected from SignalR Hub");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error disconnecting from SignalR Hub");
                }
            }
        }

        public async ValueTask DisposeAsync()
        {
            await DisconnectAsync();
        }
    }
}
