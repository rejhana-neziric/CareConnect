using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Qualification
    {
        public string Name { get; set; } = null!;

        public string InstituteName { get; set; } = null!;

        public DateTime ProcurementYear { get; set; }

        public DateTime ModifiedDate { get; set; }
    }
}
