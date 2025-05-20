using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class EmployeePayHistory
    {
        public DateTime RateChangeDate { get; set; }

        public decimal Rate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Employee Employee { get; set; } = null!;
    }
}