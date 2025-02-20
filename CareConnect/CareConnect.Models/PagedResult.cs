using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models
{
    public class PagedResult<T>
    {
        public int? Count { get; set; }

        public List<T> ResultList { get; set; }
    }
}
