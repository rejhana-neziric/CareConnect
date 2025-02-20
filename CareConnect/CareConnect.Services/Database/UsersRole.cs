using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class UsersRole
{
    public int UserId { get; set; }

    public int RoleId { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Role Role { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
