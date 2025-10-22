using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class RolePermissionsResponse
    {
        public Role Role { get; set; } = null!;

        public List<Permission> AllPermissions { get; set; } = new List<Permission>();
        
        public List<Permission> AssignedPermissions { get; set; } = new List<Permission>();
    }
}
