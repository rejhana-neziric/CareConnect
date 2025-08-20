using System;     

namespace CareConnect.Models.Responses
{
    public class Review
    {
        public int ReviewId { get; set; }

        public string Title { get; set; } = null!;

        public string Content { get; set; } = null!;

        public bool IsHidden { get; set; }

        public DateTime PublishDate { get; set; }

        public int? Stars { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Employee? Employee { get; set; }

        public virtual User User { get; set; } = null!;
    }
}    
    
   