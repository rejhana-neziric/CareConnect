using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IEmployeeService : ICRUDService<Employee, EmployeeSearchObject, EmployeeAdditionalData, EmployeeInsertRequest, EmployeeUpdateRequest>
    {
        public EmployeeStatistics GetStatistics();

        public Employee CreateEmployeeAvailability(int employeeId, List<EmployeeAvailabilityInsertRequest> availability);


        public Employee UpdateEmployeeAvailability(int employeeId, EmployeeAvailabilityChanges availability);


    }
}
