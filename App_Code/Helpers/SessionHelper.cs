using System;
using System.Web;

namespace IndustrialSparePartPortal.App_Code.Helpers
{
    public static class SessionHelper
    {
        public static int? UserId
        {
            get
            {
                if (HttpContext.Current.Session["UserId"] != null)
                {
                    return Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                }
                return null;
            }
            set
            {
                HttpContext.Current.Session["UserId"] = value;
            }
        }

        public static string UserRole
        {
            get
            {
                return HttpContext.Current.Session["UserRole"] != null ? HttpContext.Current.Session["UserRole"].ToString() : null;
            }
            set
            {
                HttpContext.Current.Session["UserRole"] = value;
            }
        }

        public static string UserEmail
        {
            get
            {
                return HttpContext.Current.Session["UserEmail"] != null ? HttpContext.Current.Session["UserEmail"].ToString() : null;
            }
            set
            {
                HttpContext.Current.Session["UserEmail"] = value;
            }
        }

        public static string FullName
        {
            get
            {
                return HttpContext.Current.Session["FullName"] != null ? HttpContext.Current.Session["FullName"].ToString() : null;
            }
            set
            {
                HttpContext.Current.Session["FullName"] = value;
            }
        }

        public static bool IsVerified
        {
            get
            {
                if (HttpContext.Current.Session["IsVerified"] != null)
                {
                    return Convert.ToBoolean(HttpContext.Current.Session["IsVerified"]);
                }
                return false;
            }
            set
            {
                HttpContext.Current.Session["IsVerified"] = value;
            }
        }

        public static string ProfileImage
        {
            get
            {
                return HttpContext.Current.Session["ProfileImage"] != null ? HttpContext.Current.Session["ProfileImage"].ToString() : null;
            }
            set
            {
                HttpContext.Current.Session["ProfileImage"] = value;
            }
        }

        public static bool IsLoggedIn
        {
            get
            {
                return UserId.HasValue && !string.IsNullOrEmpty(UserRole);
            }
        }

        public static void Logout()
        {
            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();
        }

        public static string GetDashboardUrlByRole(string role)
        {
            switch (role)
            {
                case Constants.RoleConstants.Administrator:
                    return "~/Admin/Dashboard.aspx";
                case Constants.RoleConstants.Factory:
                    return "~/Factory/Dashboard.aspx";
                case Constants.RoleConstants.Supplier:
                    return "~/Supplier/Dashboard.aspx";
                case Constants.RoleConstants.Technician:
                    return "~/Technician/Dashboard.aspx";
                default:
                    return "~/Default.aspx";
            }
        }
    }
}
