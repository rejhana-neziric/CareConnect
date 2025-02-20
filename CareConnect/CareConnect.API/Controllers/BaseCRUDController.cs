using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch> 
        where TModel : class where TSearch : BaseSearchObject where TInsert : class where TUpdate : class
    {
        protected new ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;

        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert, TUpdate> service) : base(service)
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
    }
}
