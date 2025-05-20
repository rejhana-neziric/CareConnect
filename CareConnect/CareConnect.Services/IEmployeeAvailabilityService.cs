using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IEmployeeAvailabilityService : ICRUDService<EmployeeAvailability, EmployeeAvailabilitySearchObject, EmployeeAvailabilityAdditionalData, EmployeeAvailabilityInsertRequest, EmployeeAvailabilityUpdateRequest>
    {

    }
}
