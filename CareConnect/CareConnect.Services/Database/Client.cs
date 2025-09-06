using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Client
{
    public int ClientId { get; set; }

    public bool EmploymentStatus { get; set; }

    public DateTime CreatedDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual User User { get; set; } = null!;

    public virtual ICollection<ClientsChild> ClientsChildren { get; set; } = new List<ClientsChild>();

    public virtual ICollection<Member> Members { get; set; } = new List<Member>();
}
