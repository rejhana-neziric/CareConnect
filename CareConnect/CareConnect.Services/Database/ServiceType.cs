using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.Database
{
    public partial class ServiceType
    {
        public int ServiceTypeId { get; set; }

        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public virtual ICollection<Service> Services { get; set; } = new List<Service>();
    }
}
