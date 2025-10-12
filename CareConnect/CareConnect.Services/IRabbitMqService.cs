using CareConnect.Models.Messages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IRabbitMqService
    {
        Task PublishAppointmentNotificationAsync(AppointmentNotificationMessage message);
    }
}
