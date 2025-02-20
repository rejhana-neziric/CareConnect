using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Appointment
{
    public int AppointmentId { get; set; }

    public int UserId { get; set; }

    public int EmployeeAvailabilityId { get; set; }

    public string AppointmentType { get; set; } = null!;

    public int AttendanceStatusId { get; set; }

    public DateOnly Date { get; set; }

    public string? Description { get; set; }

    public string? Note { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

    public virtual EmployeeAvailability EmployeeAvailability { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
