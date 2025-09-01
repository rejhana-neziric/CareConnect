using System;
using System.Collections.Generic;

namespace CareConnect.Models.Responses
{
    public class Employee
    {
        public DateTime HireDate { get; set; }

        public DateTime? EndDate { get; set; }

        public bool Employed => EndDate == null; 

        public string JobTitle { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }

        public virtual User User { get; set; } = null!;

        //public virtual ICollection<EmployeePayHistory> EmployeePayHistories { get; set; } = new List<EmployeePayHistory>();

        //public virtual ICollection<EmployeeAvailability> EmployeeAvailabilities { get; set; } = new List<EmployeeAvailability>();

        public virtual Qualification? Qualification { get; set; }

        //public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

        //public virtual ICollection<Session> Sessions { get; set; } = new List<Session>();
    }
}
