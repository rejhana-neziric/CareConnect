using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IReviewService : ICRUDService<Review, ReviewSearchObject, ReviewAdditionalData, ReviewInsertRequest, ReviewUpdateRequest>
    {
        public Review ChangeVisibility(int id);

        public double GetAverage(int? employeeId); 
    }
}
