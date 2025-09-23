using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Child
{
    public int ChildId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateTime BirthDate { get; set; }

    public string Gender { get; set; } = null!;

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<ChildrenDiagnosis> ChildrenDiagnoses { get; set; } = new List<ChildrenDiagnosis>();

    public virtual ICollection<ClientsChild> ClientsChildren { get; set; } = new List<ClientsChild>();

    public ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();
}
