using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace CareConnect.Models.Responses
{
    public class Appointment
    {
        public int AppointmentId { get; set; }

        public int EmployeeAvailabilityId { get; set; }

        public string AppointmentType { get; set; } = null!;

        public int AttendanceStatusId { get; set; }

        public int ClientId { get; set; }

        public int ChildId { get; set; }

        public DateTime Date { get; set; }

        public string? Description { get; set; }

        public string? Note { get; set; }

        public DateTime ModifiedDate { get; set; }

        public string? StateMachine { get; set; }

        public string? PaymentIntentId { get; set; }

        [NotMapped] 
        public bool Paid => PaymentIntentId != null;

        public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

        public virtual EmployeeAvailability EmployeeAvailability { get; set; } = null!;

        public virtual ClientsChild ClientsChild { get; set; } = null!;

    }
}
