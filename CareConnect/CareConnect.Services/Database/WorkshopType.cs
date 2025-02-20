using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class WorkshopType
{
    public int WorkshopTypeId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Workshop> Workshops { get; set; } = new List<Workshop>();
}
