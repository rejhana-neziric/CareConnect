using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class InstructorSearchObject : BaseSearchObject<InstructorAdditionalData>
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string? ProfessionalTitle { get; set; }

        public string? InstitutionName { get; set; }
    }
}
