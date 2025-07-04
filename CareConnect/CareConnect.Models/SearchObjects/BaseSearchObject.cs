using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.SearchObjects
{
    public class BaseSearchObject<TAdditionalData>
        where TAdditionalData : BaseAdditionalSearchRequestData
    {
        public string? FTS { get; set; }

        public int? Page { get; set; } = 0;

        public int? PageSize { get; set; } = 10;

        public bool IncludeTotalCount { get; set; } = false;

        public bool RetrieveAll { get; set; } = false;

        public string? SortBy { get; set; }

        public bool SortAscending { get; set; } = true;

        public TAdditionalData? AdditionalData { get; set; }
    }
}
