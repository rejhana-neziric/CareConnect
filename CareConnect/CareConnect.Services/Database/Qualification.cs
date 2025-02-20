using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Qualification
{
    public int QualificationId { get; set; }

    public string Name { get; set; } = null!;

    public string InstituteName { get; set; } = null!;

    public DateOnly ProcurementYear { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
