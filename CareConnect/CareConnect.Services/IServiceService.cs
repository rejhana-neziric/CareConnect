using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IServiceService : ICRUDService<Service, ServiceSearchObject, ServiceAdditionalData, ServiceInsertRequest, ServiceUpdateRequest>
    {
        public ServiceStatistics GetStatistics();

        public List<Employee> GetEmployeesForService(int serviceId); 

    }
}