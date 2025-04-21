using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
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
        public TModel Insert(TInsert request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public TModel Update(int id, TUpdate request)
        {
            return _service.Update(id, request);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _service.Delete(id);
        }
    }
}
