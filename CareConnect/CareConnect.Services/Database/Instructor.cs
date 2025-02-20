using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Instructor
{
    public int InstructorId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? Email { get; set; }

    public string? PhoneNumber { get; set; }

    public string ProfessionalTitle { get; set; } = null!;

    public string? InstitutionName { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Session> Sessions { get; set; } = new List<Session>();
}
