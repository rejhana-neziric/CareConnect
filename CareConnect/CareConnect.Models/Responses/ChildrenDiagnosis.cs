using System;
using System.Collections.Generic;

namespace CareConnect.Models.Responses
{
    public class ChildrenDiagnosis
    {
        public DateTime? DiagnosisDate { get; set; }

        public string? Notes { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Child Child { get; set; } = null!;

        public virtual Diagnosis Diagnosis { get; set; } = null!;
    }
}