using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class ServiceType
    {
        public int ServiceTypeId { get; set; }

        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public int? NumberOfServices { get; set; }

        //public virtual ICollection<Service> Services { get; set; } = new List<Service>();
    }
}
