using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IEmployeeService : ICRUDService<Employee, EmployeeSearchObject, EmployeeAdditionalData, EmployeeInsertRequest, EmployeeUpdateRequest>
    {

    }
}
