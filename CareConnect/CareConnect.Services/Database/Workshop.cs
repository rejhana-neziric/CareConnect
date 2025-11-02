using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Workshop
{
    public int WorkshopId { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string WorkshopType { get; set; } = null!;

    public string Status { get; set; } = null!;

    public DateTime Date { get; set; }

    public decimal? Price { get; set; }

    public int? MaxParticipants { get; set; }

    public int? Participants { get; set; } = 0;

    public string? Notes { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Participant> ParticipantsNavigation { get; set; } = new List<Participant>();

}
