using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Requests
{
    public class ServiceTypeInsertRequest
    {
        public string Name { get; set; } = null!;

        public string? Description { get; set; }
    }
}
