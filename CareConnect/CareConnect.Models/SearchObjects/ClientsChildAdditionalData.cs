using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public class ClientsChildAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsClientIncluded { get; set; }

        public bool? IsChildIncluded { get; set; }
    }
}
