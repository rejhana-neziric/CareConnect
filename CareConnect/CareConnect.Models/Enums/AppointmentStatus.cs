using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Enums
{
    public enum AppointmentStatus
    {
        Scheduled = 0,
        Confirmed = 1,
        Rescheduled = 2,
        RescheduleRequested = 3,
        ReschedulePendingApproval = 4,
        Completed = 5,
        Canceled = 6,
        Started = 7
    }
}
