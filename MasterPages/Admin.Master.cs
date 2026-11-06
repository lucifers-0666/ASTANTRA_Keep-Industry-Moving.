using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using System;
using System.Web.UI;

namespace IndustrialSparePartPortal.MasterPages
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verify Administrator Authorization
            if (!SessionHelper.IsLoggedIn || !string.Equals(SessionHelper.UserRole, RoleConstants.Administrator, StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Account/AccessDenied.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                // Auto-populate breadcrumb label from the page's <title> tag
                // Page.Title format: "Dashboard - ASTANTRA Administrator Console"
                // Extract the first segment before " - " as the page-specific label
                string pageTitle = Page.Title ?? string.Empty;
                if (pageTitle.Contains(" - "))
                {
                    pageTitle = pageTitle.Substring(0, pageTitle.IndexOf(" - "));
                }
                lblPageHeader.InnerText = string.IsNullOrWhiteSpace(pageTitle) ? "Console" : pageTitle.Trim();

                lblAdminName.InnerText = SessionHelper.FullName ?? "Administrator";
            }
        }
    }
}
