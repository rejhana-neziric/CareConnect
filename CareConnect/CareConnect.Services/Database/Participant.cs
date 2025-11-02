using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Participant
{
    public int ParticipantId { get; set; }
    public int UserId { get; set; }

    public int WorkshopId { get; set; }

    public int? ChildId { get; set; }

    public int AttendanceStatusId { get; set; }

    public DateTime RegistrationDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public string? PaymentIntentId { get; set; }

    public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

    public virtual User User { get; set; } = null!;

    public virtual Workshop Workshop { get; set; } = null!;

    public virtual Child? Child { get; set; }
}
