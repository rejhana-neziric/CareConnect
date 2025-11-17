using CareConnect.API.Filters;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseCRUDController<TModel, TSearch, TSearchAdditionalData, TInsert, TUpdate> : BaseController<TModel, TSearch, TSearchAdditionalData> 
        where TModel : class 
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
        where TInsert : class 
        where TUpdate : class
    {
        protected new ICRUDService<TModel, TSearch, TSearchAdditionalData, TInsert, TUpdate> _service;

        public BaseCRUDController(ICRUDService<TModel, TSearch, TSearchAdditionalData,  TInsert, TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        [PermissionAuthorize("Insert")]
        public virtual TModel Insert(TInsert request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        [PermissionAuthorize("Update")]
        public virtual TModel Update(int id, TUpdate request)
        {
            return _service.Update(id, request);
        }

        [HttpDelete("{id}")]
        [PermissionAuthorize("Delete")]
        public virtual IActionResult Delete(int id)
        {
            var result = _service.Delete(id);
            return Ok(result);
        }
    }
}
