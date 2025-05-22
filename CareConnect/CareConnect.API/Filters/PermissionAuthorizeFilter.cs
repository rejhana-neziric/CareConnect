using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;

namespace CareConnect.API.Filters
{
    public class PermissionAuthorizeFilter : IAuthorizationFilter
    {
        private readonly string _action;

        public PermissionAuthorizeFilter(string action)
        {
            _action = action;
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            if (context.ActionDescriptor.EndpointMetadata.OfType<AllowAnonymousAttribute>().Any())
            {
                return;
            }

            var user = context.HttpContext.User;

            if (!(context.ActionDescriptor is ControllerActionDescriptor cad))
            {
                context.Result = new ForbidResult();
                return;
            }

            var controllerType = cad.ControllerTypeInfo.AsType();
            var baseType = controllerType.BaseType;
            var modelType = baseType?.GenericTypeArguments.FirstOrDefault();
            var modelName = modelType?.Name ?? cad.ControllerName;

            var requiredPermission = $"Permissions.{modelName}.{_action}";

            var userService = context.HttpContext.RequestServices.GetService<IUserService>();

            if (userService == null) return; 

            var username = user.Identity?.Name;

            if (username == null || !userService.GetPermissions(username).Contains(requiredPermission))
            {
                context.Result = new ForbidResult();
            }
        }
    }
}
