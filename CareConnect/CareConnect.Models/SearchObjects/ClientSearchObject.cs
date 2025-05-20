using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ClientSearchObject : BaseSearchObject<ClientAdditionalData>
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? Email { get; set; }

        public bool? EmploymentStatus { get; set; }
    }
}
