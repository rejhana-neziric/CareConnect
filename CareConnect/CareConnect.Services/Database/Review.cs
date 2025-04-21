using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Review
{
    public int ReviewId { get; set; }

    public int UserId { get; set; }

    public string Title { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime PublishDate { get; set; }

    public int? WorkshopId { get; set; }

    public int? EmployeeId { get; set; }

    public int? Stars { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Employee? Employee { get; set; }

    public virtual User User { get; set; } = null!;

    public virtual Workshop? Workshop { get; set; }
}
