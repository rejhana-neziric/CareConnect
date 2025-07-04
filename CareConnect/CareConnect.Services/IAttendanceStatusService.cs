using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IAttendanceStatusService : IService<AttendanceStatus, AttendanceStatusSearchObject, AttendanceStatusAdditionalData>
    {
    }
}
