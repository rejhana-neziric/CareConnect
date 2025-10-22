using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.Helpers
{
    public static class PermissionNameParser
    {
        public static string ParseCategory(string permissionName)
        {
            var parts = permissionName.Split('.');
            return parts.Length > 0 ? parts[0] : "Unknown";
        }

        public static string ParseResource(string permissionName)
        {
            var parts = permissionName.Split('.');
            return parts.Length > 1 ? parts[1] : "Unknown";
        }

        public static string ParseAction(string permissionName)
        {
            var parts = permissionName.Split('.');
            return parts.Length > 2 ? parts[2] : "Unknown";
        }
    }
}
