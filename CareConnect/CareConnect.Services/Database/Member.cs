using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Member
{
    public int MemberId { get; set; }

    public DateTime JoinedDate { get; set; }

    public DateTime? LeftDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Client Client { get; set; } = null!;
}
