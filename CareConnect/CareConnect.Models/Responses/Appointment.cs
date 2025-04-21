using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Appointment
    {
        public string UserFirstName { get; set; }

        public string UserLastName { get; set; }

        public string ChildFirstName { get; set; }

        public string ChildLastName { get; set; }

        public string EmployeeAvailabilityEmployeeEmployeeNavigationFirstName { get; set; }

        public string EmployeeAvailabilityEmployeeEmployeeNavigationLastName { get; set; }

        public string EmployeeAvailabilityServiceName { get; set; }

        public string AppointmentType { get; set; } = null!;

        public string AttendanceStatusName { get; set; }

        public string? Description { get; set; }

        public string? Note { get; set; }

        public DateTime ModifiedDate { get; set; }
    }
}
