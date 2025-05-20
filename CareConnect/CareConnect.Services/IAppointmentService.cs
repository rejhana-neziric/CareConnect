using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IAppointmentService : ICRUDService<Appointment, AppointmentSearchObject, AppointmentAdditionalData, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
    }
}
