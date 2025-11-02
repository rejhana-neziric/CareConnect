using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public class AttendanceStatusService : 
        BaseCRUDService<Models.Responses.AttendanceStatus, AttendanceStatusSearchObject, AttendanceStatusAdditionalData, Database.AttendanceStatus, AttendanceStatusUpsertRequest, AttendanceStatusUpsertRequest>, IAttendanceStatusService
    {

        public AttendanceStatusService(CareConnectContext context, IMapper mapper)
            : base(context, mapper)
        {

        }

        public override bool Delete(int id)
        {
            var isUsedAppointments = Context.Appointments.Any(a => a.AttendanceStatusId == id);
            var isUsedWorkshops = Context.Participants.Any(a => a.AttendanceStatusId == id);

            if (isUsedAppointments || isUsedWorkshops)
                return false; 

            var status = Context.AttendanceStatuses.Find(id);

            if (status != null)
            {
                Context.AttendanceStatuses.Remove(status);
                Context.SaveChanges();
                return true;
            }

            return false;
        }
    }
}
