using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseController<TModel, TSearch, TSearchAdditionalData> : ControllerBase 
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
    {
        protected IService<TModel, TSearch, TSearchAdditionalData> _service;

        public BaseController(IService<TModel, TSearch, TSearchAdditionalData> service)
        {
            _service = service;
        }

        [HttpGet]
        public PagedResult<TModel> GetList([FromQuery] TSearch searchObject)
        {
            return _service.Get(searchObject);
        }

        [HttpGet("{id}")]
        public TModel GetById(int id, [FromQuery] TSearchAdditionalData additionalData)
        {
            return _service.GetById(id, additionalData);
        }
    }
}
