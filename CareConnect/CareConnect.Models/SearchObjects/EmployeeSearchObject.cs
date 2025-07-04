using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeeSearchObject : BaseSearchObject<EmployeeAdditionalData>
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? Email { get; set; }

        public string? JobTitle { get; set; }

        public bool? Employed { get; set; }

        public DateTime? HireDateGTE { get; set; }

        public DateTime? HireDateLTE { get; set; }
    }
}
