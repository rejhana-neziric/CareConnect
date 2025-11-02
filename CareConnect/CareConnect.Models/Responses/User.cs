using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class User
    {
        public int UserId { get; set; }

        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string Username { get; set; } = null!;

        public bool Status { get; set; }

        public DateTime? BirthDate { get; set; }

        public string Gender { get; set; } = null!;

        public string? Address { get; set; }

        public virtual ICollection<UsersRole> UsersRoles { get; set; } = new List<UsersRole>();

        public List<string> Roles { get; set; } = new List<string>();
    }
}
