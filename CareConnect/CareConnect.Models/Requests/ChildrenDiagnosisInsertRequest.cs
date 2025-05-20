using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ChildrenDiagnosisInsertRequest
    {
        public int ChildId { get; set; }

        public int DiagnosisId { get; set; }

        public DateTime? DiagnosisDate { get; set; }

        public string? Notes { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
