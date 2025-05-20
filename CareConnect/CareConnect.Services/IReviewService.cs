using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IReviewService : ICRUDService<Review, ReviewSearchObject, ReviewAdditionalData, ReviewInsertRequest, ReviewUpdateRequest>
    {
    }
}
