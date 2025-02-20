using System;
using System.Collections.Generic;

namespace CareConnect.Services.Database;

public partial class EmployeePayHistory
{
    public int EmployeeId { get; set; }

    public DateOnly RateChangeDate { get; set; }

    public decimal Rate { get; set; }

    public DateTime ModifiedDate { get; set; }

    public virtual Employee Employee { get; set; } = null!;
}
