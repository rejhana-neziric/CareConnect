using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class RoleUpdateRequest
    {
        public string? Name { get; set; } = null!;

        public string? Description { get; set; }
    }
}
