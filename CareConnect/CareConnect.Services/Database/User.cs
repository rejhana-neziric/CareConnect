using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class User
{
    public int UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? Email { get; set; }

    public string? PhoneNumber { get; set; }

    public string Username { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public bool Status { get; set; }

    public DateOnly? BirthDate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public string Gender { get; set; } = null!;

    public string? Address { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Client? Client { get; set; }

    public virtual Employee? Employee { get; set; }

    public virtual ICollection<Participant> Participants { get; set; } = new List<Participant>();

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<UsersRole> UsersRoles { get; set; } = new List<UsersRole>();
}
