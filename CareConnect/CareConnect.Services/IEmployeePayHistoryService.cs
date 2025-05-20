using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IEmployeePayHistoryService : ICRUDService<EmployeePayHistory, EmployeePayHistorySearchObject, EmployeePayHistoryAdditionalData, EmployeePayHistoryInsertRequest, EmployeePayHistoryUpdateRequest>
    {

    }
}
