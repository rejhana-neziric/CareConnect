using System;

namespace CareConnect.Models.Responses
{
    public class Service
    {
        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }

        public DateTime ModifiedDate { get; set; }

        //public virtual ICollection<EmployeeAvailability> EmployeeAvailabilities { get; set; } = new List<EmployeeAvailability>();
    }
}
