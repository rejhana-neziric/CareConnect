using CareConnect.Models.Messages;
using CareConnect.Models.Responses;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System.Collections.Concurrent;
using System.Security.Claims;
using System.Text.RegularExpressions;

namespace CareConnect.Api.Hubs
{
    public class NotificationHub : Hub
    {
        private static readonly ConcurrentDictionary<int, HashSet<string>> UserConnections = new();
        private readonly ILogger<NotificationHub> _logger;

        public NotificationHub(ILogger<NotificationHub> logger)
        {
            _logger = logger;
        }

        public override async Task OnConnectedAsync()
        {
            var userIdClaim = Context.User?.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            if (userIdClaim != null && int.TryParse(userIdClaim, out int userId))
            {
                if (!UserConnections.ContainsKey(userId))
                {
                    UserConnections[userId] = new HashSet<string>();
                }

                UserConnections[userId].Add(Context.ConnectionId);

                await Groups.AddToGroupAsync(Context.ConnectionId, $"user_{userId}");

                _logger.LogInformation("✓ User {UserId} connected with ConnectionId {ConnectionId}",
                    userId, Context.ConnectionId);

                await Clients.Caller.SendAsync("Connected", new { userId, connectionId = Context.ConnectionId });
            }
            else
            {
                _logger.LogWarning("❌ Connection attempt without userId");
            }

            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            var userIdClaim = Context.User?.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            if (int.TryParse(userIdClaim, out int userId) && UserConnections.ContainsKey(userId))
            {
                UserConnections[userId].Remove(Context.ConnectionId);

                if (UserConnections[userId].Count == 0)
                {
                    UserConnections.TryRemove(userId, out _);
                }

                await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"user_{userId}");

                _logger.LogInformation("User {UserId} disconnected", userId);
            }

            await base.OnDisconnectedAsync(exception);
        }

        public async Task RegisterUser(int userId)
        {
            if (!UserConnections.ContainsKey(userId))
            {
                UserConnections[userId] = new HashSet<string>();
            }

            UserConnections[userId].Add(Context.ConnectionId);
            await Groups.AddToGroupAsync(Context.ConnectionId, $"user_{userId}");

            _logger.LogInformation("User {UserId} registered with ConnectionId {ConnectionId}",
                userId, Context.ConnectionId);
        }

        public async Task SendNotificationToUser(int userId, Notification notification)
        {
            _logger.LogInformation(
                "Sending notification to user {UserId}: {Title}",
                userId,
                notification.Title);

            try
            {
                await Clients.Group($"user_{userId}").SendAsync("ReceiveNotification", notification);

                _logger.LogInformation("✓ Notification sent to user {UserId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "❌ Error sending notification to user {UserId}", userId);
                throw;
            }
        }

        public Task<bool> IsUserConnected(int userId)
        {
            var isConnected = UserConnections.ContainsKey(userId) && UserConnections[userId].Count > 0;
            return Task.FromResult(isConnected);
        }

        public Task<int> GetUserConnectionCount(int userId)
        {
            var count = UserConnections.TryGetValue(userId, out var connections) ? connections.Count : 0;
            return Task.FromResult(count);
        }

        public static HashSet<string>? GetUserConnections(int userId)
        {
            return UserConnections.TryGetValue(userId, out var connections) ? connections : null;
        }

        public static bool IsUserOnline(int userId)
        {
            return UserConnections.ContainsKey(userId) && UserConnections[userId].Count > 0;
        }
    }
}
