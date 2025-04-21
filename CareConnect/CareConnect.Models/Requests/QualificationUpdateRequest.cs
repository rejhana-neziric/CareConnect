using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class QualificationUpdateRequest
    {
        public string? Name { get; set; }

        public string? InstituteName { get; set; }

        public DateTime? ProcurementYear { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
} 