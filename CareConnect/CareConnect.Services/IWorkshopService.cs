using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IWorkshopService : ICRUDService<Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {

        public Workshop Cancel(int id);

        public Workshop Close(int id);

        public Workshop Publish(int id);

        public List<string> AllowedActions(int id);

        public WorkshopStatistics GetStatistics(); 
    }
}