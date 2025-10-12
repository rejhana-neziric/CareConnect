using CareConnect.Models.Enums;
using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Messages
{
    public class AppointmentNotificationMessage
    {
        public int AppointmentId { get; set; }

        public int ClientId { get; set; }

        public int EmployeeId { get; set; }

        public AppointmentStatus Status { get; set; }

        public DateTime AppointmentDate { get; set; }

        public string ServiceName { get; set; }

        public DateTime ChangedAt { get; set; }
    }
}
