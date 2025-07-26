using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class ClientsChildStatistics
    {
        public int TotalParents { get; set; }

        public int TotalChildren { get; set; }

        public int EmployedParents { get; set; }

        public int NewClientsThisMonth { get; set; }

        public List<AgeGroup> ChildrenPerAgeGroup { get; set; } = new List<AgeGroup>();

        public List<GenderGroup> ChildrenPerGender { get; set; } = new List<GenderGroup>();
    }
}
