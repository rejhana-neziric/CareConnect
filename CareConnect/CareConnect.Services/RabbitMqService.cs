using CareConnect.Models.Messages;
using EasyNetQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class RabbitMqService : IRabbitMqService, IDisposable
    {
        private readonly IBus _bus;
        
        private readonly ILogger<RabbitMqService> _logger;

        public RabbitMqService(IConfiguration configuration, ILogger<RabbitMqService> logger)
        {
            _logger = logger;

            var rabbitHost = Environment.GetEnvironmentVariable("RABBIT_HOST");
            var rabbitPort = int.Parse(Environment.GetEnvironmentVariable("RABBIT_PORT") ?? "5672");
            var rabbitUser = Environment.GetEnvironmentVariable("RABBIT_USER");
            var rabbitPassword = Environment.GetEnvironmentVariable("RABBIT_PASSWORD");

            var connectionString = $"host={rabbitHost};username={rabbitUser};password={rabbitPassword}";

            //var connectionString = configuration.GetConnectionString("RabbitMQ")
            //    ?? "host=localhost;username=guest;password=guest";

            try
            {
                _bus = RabbitHutch.CreateBus(connectionString);
                _logger.LogInformation("RabbitMQ connection established");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to connect to RabbitMQ");
                throw;
            }
        }


        public async Task PublishAppointmentNotificationAsync(AppointmentNotificationMessage message)
        {
            //try
            //{
            //    await _bus.PubSub.PublishAsync(message, "appointment.created");

            //    _logger.LogInformation("Published appointment notification for AppointmentId: {AppointmentId}",
            //        message);
            //}
            //catch (Exception ex)
            //{
            //    _logger.LogError(ex, "Failed to publish appointment notification");
            //    throw;
            //}
            int retries = 3;
            while (retries > 0)
            {
                try
                {
                    await _bus.PubSub.PublishAsync(message, "appointment.created");
                    return;
                }
                catch (TaskCanceledException ex)
                {
                    retries--;
                    if (retries == 0) throw;
                    _logger.LogWarning("Publish failed, retrying... ({Retries} left)", retries);
                    await Task.Delay(2000);
                }
            }
        }

        public void Dispose()
        {
            _bus?.Dispose();
        }
    }
}
