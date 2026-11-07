using System;
using System.Web.UI;

namespace IndustrialSparePartPortal.App_Code.Helpers
{
    /// <summary>
    /// Base Page class for secured ASP.NET Web Forms pages to enforce Role-Based Access Control.
    /// </summary>
    public class BasePage : Page
    {
        public string RequiredRole { get; set; }
        public bool RequireVerification { get; set; }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            // Check if user is logged in
            if (!SessionHelper.IsLoggedIn)
            {
                Response.Redirect("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl), true);
                return;
            }

            // Check if page requires specific role
            if (!string.IsNullOrEmpty(RequiredRole))
            {
                if (!string.Equals(SessionHelper.UserRole, RequiredRole, StringComparison.OrdinalIgnoreCase))
                {
                    try
                    {
                        var audit = new Logic.AuditLogic();
                        audit.logAction(SessionHelper.UserId, "AUTH_ACCESS_DENIED", "Security", null, null, 
                            string.Format("Role access denied for {0} to {1}. Required: {2}, UserRole: {3}", SessionHelper.UserEmail, Request.RawUrl, RequiredRole, SessionHelper.UserRole), 
                            Request.UserHostAddress);
                    }
                    catch { }

                    Response.Redirect("~/Account/AccessDenied.aspx", true);
                    return;
                }
            }

            // Check if verification is required
            if (RequireVerification && !SessionHelper.IsVerified && !string.Equals(SessionHelper.UserRole, Constants.RoleConstants.Administrator, StringComparison.OrdinalIgnoreCase))
            {
                // Unverified users can still access profile pages to complete verification
                string currentPath = Request.AppRelativeCurrentExecutionFilePath.ToLower();
                if (!currentPath.Contains("/profile/"))
                {
                    Response.Redirect(SessionHelper.GetDashboardUrlByRole(SessionHelper.UserRole) + "?unverified=true", true);
                    return;
                }
            }
        }
    }
}
