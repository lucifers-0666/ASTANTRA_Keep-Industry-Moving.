using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Web.UI;

namespace IndustrialSparePartPortal.Account
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (SessionHelper.IsLoggedIn)
                {
                    var audit = new AuditLogic();
                    audit.logAction(SessionHelper.UserId, "AUTH_LOGOUT", "Users", SessionHelper.UserId, null, 
                        $"User logged out: {SessionHelper.UserEmail} ({SessionHelper.UserRole})", 
                        Request.UserHostAddress);
                }
            }
            catch { }

            SessionHelper.Logout();
            Response.Redirect("~/Account/Login.aspx?logout=true");
        }
    }
}
