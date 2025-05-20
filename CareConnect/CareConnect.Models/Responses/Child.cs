using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Child
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public DateTime BirthDate { get; set; }

        public string Gender { get; set; } = null!;

        //public virtual ICollection<ChildrenDiagnosis> ChildrenDiagnoses { get; set; } = new List<ChildrenDiagnosis>();

        public virtual ICollection<Diagnosis> Diagnoses { get; set; } = new List<Diagnosis>();


        //public virtual ICollection<ClientsChild> ClientsChildren { get; set; } = new List<ClientsChild>();
    }
}
