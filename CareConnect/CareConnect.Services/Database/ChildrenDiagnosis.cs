using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class ChildrenDiagnosis
{
    public int ChildId { get; set; }

    public int DiagnosisId { get; set; }

    public DateOnly? DiagnosisDate { get; set; }

    public string? Notes { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Child Child { get; set; } = null!;

    public virtual Diagnosis Diagnosis { get; set; } = null!;
}
