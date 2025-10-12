using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Subscriber
{
    public interface INotificationService
    {
        Task SendNotificationAsync(int userId, string title, string body, Dictionary<string, object>? data = null);

        Task InitializeAsync();

        Task DisconnectAsync();
        
        bool IsConnected { get; }
    }
}
