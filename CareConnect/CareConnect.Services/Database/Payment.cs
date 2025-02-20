using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Payment
{
    public int PaymentId { get; set; }

    public int UserId { get; set; }

    public decimal Amount { get; set; }

    public DateOnly PaymentDate { get; set; }

    public int PaymentStatusId { get; set; }

    public int PaymentPurposeId { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual PaymentPurpose PaymentPurpose { get; set; } = null!;

    public virtual PaymentStatus PaymentStatus { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
