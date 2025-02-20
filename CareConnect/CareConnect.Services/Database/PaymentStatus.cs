using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class PaymentStatus
{
    public int PaymentStatusId { get; set; }

    public string Name { get; set; } = null!;

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
