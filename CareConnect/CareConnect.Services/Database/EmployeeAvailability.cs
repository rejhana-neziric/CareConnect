using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class EmployeeAvailability
{
    public int EmployeeAvailabilityId { get; set; }

    public int EmployeeId { get; set; }

    public int? ServiceId { get; set; }

    public string DayOfWeek { get; set; } = null!;

    public DateTime StartTime { get; set; }

    public DateTime EndTime { get; set; }

    public bool IsAvailable { get; set; }

    public string? ReasonOfUnavailability { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Employee Employee { get; set; } = null!;

    public virtual Service? Service { get; set; }
}
