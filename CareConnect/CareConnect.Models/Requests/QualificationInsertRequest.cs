using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class QualificationInsertRequest
    {
        public string Name { get; set; } = null!;

        public string InstituteName { get; set; } = null!;

        public DateTime ProcurementYear { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
