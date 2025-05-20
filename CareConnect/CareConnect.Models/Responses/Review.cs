using System;     

namespace CareConnect.Models.Responses
{
    public class Review
    {
        public string Title { get; set; } = null!;

        public string Content { get; set; } = null!;

        public DateTime PublishDate { get; set; }

        public int? Stars { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Employee? Employee { get; set; }

        public virtual User User { get; set; } = null!;

        public virtual Workshop? Workshop { get; set; }
    }
}    
    
   