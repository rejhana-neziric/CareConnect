using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IWorkshopService : ICRUDService<Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {
    }
}