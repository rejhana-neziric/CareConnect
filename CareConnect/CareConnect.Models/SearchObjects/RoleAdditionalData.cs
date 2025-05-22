using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public class RoleAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsPermissionIncluded { get; set; }
    }
}
