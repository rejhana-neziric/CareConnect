using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Permission
    {
        public int PermissionId { get; set; }
        
        public string Name { get; set; } = null!;
        
        public string Category { get; set; } = null!;

        public string Action { get; set; } = null!;
        
        public string Resource { get; set; } = null!;
    }
}
