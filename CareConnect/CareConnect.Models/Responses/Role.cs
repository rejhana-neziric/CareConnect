using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Role
    {
        public int RoleId { get; set; }
        
        public string Name { get; set; } = null!;
        
        public string? Description { get; set; }
        
        public int UserCount { get; set; }
        
        public List<int> PermissionIds { get; set; } = new List<int>();
    }
}
