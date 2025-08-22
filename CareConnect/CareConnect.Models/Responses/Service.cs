using System;

namespace CareConnect.Models.Responses
{
    public class Service
    {
        public int ServiceId { get; set; }

        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }

        public int ServiceTypeId { get; set; }


        public ServiceType ServiceType { get; set; }

        public bool IsActive { get; set; } 

        public DateTime ModifiedDate { get; set; }

        //public virtual ICollection<EmployeeAvailability> EmployeeAvailabilities { get; set; } = new List<EmployeeAvailability>();
    }
}
