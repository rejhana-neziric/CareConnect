using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class UsersRole
    {
        public int UserId { get; set; }

        public int RoleId { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Role Role { get; set; } = null!;
    }
}
