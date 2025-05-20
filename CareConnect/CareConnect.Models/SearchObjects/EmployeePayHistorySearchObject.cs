using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeePayHistorySearchObject : BaseSearchObject<EmployeePayHistoryAdditionalData>
    {
        public DateTime? RateChangeDateGTE { get; set; }

        public DateTime? RateChangeDateLTE { get; set; }

        public decimal? Rate { get; set; }

        public string? EmployeeFirstNameGTE { get; set; }

        public string? EmployeeLastNameGTE { get; set; }
    }
}