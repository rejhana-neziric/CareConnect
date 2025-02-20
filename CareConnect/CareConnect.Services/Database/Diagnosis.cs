using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Diagnosis
{
    public int DiagnosisId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<ChildrenDiagnosis> ChildrenDiagnoses { get; set; } = new List<ChildrenDiagnosis>();
}
