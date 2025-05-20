using System;

namespace CareConnect.Models.Responses
{
    public class Appointment
    {
        public string AppointmentType { get; set; } = null!;

        public DateTime Date { get; set; }

        public string? Description { get; set; }

        public string? Note { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

        public virtual EmployeeAvailability EmployeeAvailability { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
