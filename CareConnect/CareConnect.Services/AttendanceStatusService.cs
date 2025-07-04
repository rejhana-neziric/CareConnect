using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class AttendanceStatusService : BaseService<Models.Responses.AttendanceStatus, AttendanceStatusSearchObject, AttendanceStatusAdditionalData, AttendanceStatus>, IAttendanceStatusService
    {
        public AttendanceStatusService(CareConnectContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
