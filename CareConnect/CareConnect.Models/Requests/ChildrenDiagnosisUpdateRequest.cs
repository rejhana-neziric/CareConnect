using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ChildrenDiagnosisUpdateRequest
    {
        public DateTime? DiagnosisDate { get; set; }

        public string? Notes { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
