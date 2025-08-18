using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class WorkshopType
    {
        public int WorkshopTypeId { get; set; }

        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public DateTime ModifiedDate { get; set; }
     }
}
