using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class ClientsChild
{
    public int ClientId { get; set; }

    public int ChildId { get; set; }

    public DateTime ModifiedDate { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Child Child { get; set; } = null!;

    public virtual Client Client { get; set; } = null!;

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
}
