using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    //public class AppointmentService : BaseCRUDService<Models.Responses.Appointment, AppointmentSearchObject, Database.Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService    
    //{
    //    public AppointmentService(_210024Context context, IMapper mapper) : base(context, mapper) { }

    //    public override IQueryable<Database.Appointment> AddFilter(AppointmentSearchObject search, IQueryable<Database.Appointment> query)
    //    {
    //        var filteredQuery =  base.AddFilter(search, query);

    //        filteredQuery = filteredQuery.Include(x => x.User).Include(x => x.EmployeeAvailability).ThenInclude(x => x.Employee).Include(x => x.AttendanceStatus); 

    //        return filteredQuery;   
    //    }
    //}
}
