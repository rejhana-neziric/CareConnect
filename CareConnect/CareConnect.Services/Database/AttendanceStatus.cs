using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class AttendanceStatus
{
    public int AttendanceStatusId { get; set; }

    public string Name { get; set; } = null!;

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual ICollection<Participant> Participants { get; set; } = new List<Participant>();
}
