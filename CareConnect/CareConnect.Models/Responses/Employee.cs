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

        public virtual Qualification? Qualification { get; set; }
    }
}
