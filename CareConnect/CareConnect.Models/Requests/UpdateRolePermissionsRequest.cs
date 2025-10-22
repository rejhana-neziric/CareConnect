using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class UpdateRolePermissionsRequest
    {
        public int RoleId { get; set; }

        public List<int> PermissionIds { get; set; } = new List<int>(); 
    }
}
