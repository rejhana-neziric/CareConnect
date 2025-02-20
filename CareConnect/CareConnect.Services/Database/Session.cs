using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Session
{
    public int SessionId { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public int WorkshopId { get; set; }

    public int? EmployeeId { get; set; }

    public int? InstructorId { get; set; }

    public DateOnly Date { get; set; }

    public TimeOnly StartTime { get; set; }

    public TimeOnly EndTime { get; set; }

    public DateTime ModifiedDate { get; set; }

    public string Status { get; set; } = null!;

    public virtual Employee? Employee { get; set; }

    public virtual Instructor? Instructor { get; set; }

    public virtual Workshop Workshop { get; set; } = null!;
}
