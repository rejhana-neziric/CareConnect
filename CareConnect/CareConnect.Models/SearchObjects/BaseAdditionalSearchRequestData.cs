using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public partial class BaseAdditionalSearchRequestData
    {
        public BaseAdditionalSearchRequestData()
        {
            IncludeList = new List<string>();
        }
       
        public IList<string> IncludeList { get; set; }
    }
}
