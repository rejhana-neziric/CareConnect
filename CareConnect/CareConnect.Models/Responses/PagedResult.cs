using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class PagedResult<T>
    {
        public int? TotalCount { get; set; }

        public List<T> ResultList { get; set; }
    }
}
