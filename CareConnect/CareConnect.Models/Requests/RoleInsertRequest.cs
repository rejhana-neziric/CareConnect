using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Security;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class RoleInsertRequest
    {
        public string Name { get; set; } = null!;

        public string? Description { get; set; }
    }
}
