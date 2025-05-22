using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public class UsersRoleAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        public bool? IsRoleIncluded { get; set; }
    }
}
