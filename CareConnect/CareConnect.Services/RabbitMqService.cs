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
            var connectionString = configuration.GetConnectionString("RabbitMQ")
                ?? "host=localhost;username=guest;password=guest";

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
            try
            {
                await _bus.PubSub.PublishAsync(message, "appointment.created");

                _logger.LogInformation("Published appointment notification for AppointmentId: {AppointmentId}",
                    message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to publish appointment notification");
                throw;
            }
        }

        public void Dispose()
        {
            _bus?.Dispose();
        }
    }
}
