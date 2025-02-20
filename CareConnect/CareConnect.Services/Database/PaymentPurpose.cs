using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class PaymentPurpose
{
    public int PaymentPurposeId { get; set; }

    public string Name { get; set; } = null!;

    public DateTime ModifiedDate { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
