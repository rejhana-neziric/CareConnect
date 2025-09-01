using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeeAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        public bool? IsQualificationIncluded { get; set; }

        //public bool? IsEmployeeAvailabilityIncluded { get; set; }

    }
}
