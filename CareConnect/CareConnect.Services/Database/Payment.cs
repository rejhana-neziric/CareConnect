using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class Payment
{
    public int PaymentId { get; set; }

    public string PaymentIntentId { get; set; } = null!;

    public int UserId { get; set; }

    public int? ChildId { get; set; }

    public string ItemType { get; set; } = null!;

    public int? WorkshopId { get; set; }

    public decimal Amount { get; set; }

    public string Currency { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public DateTime? CompletedAt { get; set; }

    public string Status { get; set; } = null!;

    public int? EmployeeAvailabilityId { get; set; }

    public DateTime? AppointmentDate { get; set; }

    public virtual User User { get; set; } = null!;
}
