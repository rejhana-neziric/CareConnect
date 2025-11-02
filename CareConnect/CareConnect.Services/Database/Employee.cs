using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Employee
{
    public int EmployeeId { get; set; }

    public DateTime HireDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string JobTitle { get; set; } = null!;

    public int? QualificationId { get; set; }

    public DateTime ModifiedDate { get; set; }

    public DateTime CreatedAt { get; set; } 

    public virtual ICollection<EmployeeAvailability> EmployeeAvailabilities { get; set; } = new List<EmployeeAvailability>();

    public virtual User User { get; set; } = null!;

    public virtual Qualification? Qualification { get; set; }

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
