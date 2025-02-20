using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Participant
{
    public int UserId { get; set; }

    public int WorkshopId { get; set; }

    public int AttendanceStatusId { get; set; }

    public DateOnly RegistrationDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

    public virtual User User { get; set; } = null!;

    public virtual Workshop Workshop { get; set; } = null!;
}
