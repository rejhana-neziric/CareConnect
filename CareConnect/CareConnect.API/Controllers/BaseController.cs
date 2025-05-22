using CareConnect.API.Filters;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
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
        [PermissionAuthorize("Get")]
        public virtual PagedResult<TModel> GetList([FromQuery] TSearch searchObject)
        {
            return _service.Get(searchObject);
        }

        [HttpGet("{id}")]
        [PermissionAuthorize("GetById")]
        public virtual TModel GetById(int id, [FromQuery] TSearchAdditionalData additionalData)
        {
            return _service.GetById(id, additionalData);
        }
    }
}
