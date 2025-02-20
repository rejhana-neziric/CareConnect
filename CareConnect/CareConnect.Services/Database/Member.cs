using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Member
{
    public int MemberId { get; set; }

    public DateOnly JoinedDate { get; set; }

    public DateOnly? LeftDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Client MemberNavigation { get; set; } = null!;
}
