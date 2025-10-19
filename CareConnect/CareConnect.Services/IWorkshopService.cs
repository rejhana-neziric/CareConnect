using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.WorkshopML;
using Microsoft.ML.Data;

namespace CareConnect.Services
{
    public interface IWorkshopService : ICRUDService<Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {
        public Workshop Cancel(int id);

        public Workshop Close(int id);

        public Workshop Publish(int id);

        public List<string> AllowedActions(int id);

        public WorkshopStatistics GetStatistics();

        public Task<bool> EnrollInWorkshopAsync(int clientId, int? childId, int workshopId, string? paymentIntentId = null);

        public Task<bool> IsEnrolledInWorkshopAsync(int client, int? childId, int workshopId);
    }
}