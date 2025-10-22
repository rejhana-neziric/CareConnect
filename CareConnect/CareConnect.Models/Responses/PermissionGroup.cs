using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class PermissionGroup
    {
        public string Category { get; set; } = null!;

        public List<Permission> Permissions { get; set; } = new List<Permission>();
    }
}
