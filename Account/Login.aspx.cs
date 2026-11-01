using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Web.UI;

namespace IndustrialSparePartPortal.Account
{
    public partial class Login : Page
    {
        private readonly UserLogic _userLogic = new UserLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (SessionHelper.IsLoggedIn)
            {
                Response.Redirect(SessionHelper.GetDashboardUrlByRole(SessionHelper.UserRole));
            }

            if (!IsPostBack && Request.QueryString["registered"] == "true")
            {
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-start gap-2.5";
                litAlertMessage.Text = "Registration completed successfully. Please sign in with your email and password.";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string errorMessage;
            int userId;
            string roleName;
            string fullName;
            bool isVerified;

            if (_userLogic.authenticateUser(email, password, out errorMessage, out userId, out roleName, out fullName, out isVerified))
            {
                string returnUrl = Request.QueryString["returnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                {
                    Response.Redirect(Server.UrlDecode(returnUrl));
                }
                else
                {
                    Response.Redirect(SessionHelper.GetDashboardUrlByRole(roleName));
                }
            }
            else
            {
                pnlAlert.Visible = true;
                litAlertMessage.Text = errorMessage;
            }
        }
    }
}
