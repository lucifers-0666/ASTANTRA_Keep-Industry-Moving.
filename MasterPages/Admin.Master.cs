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

                // Bind Administrator Avatar
                if (SessionHelper.UserId.HasValue)
                {
                    string profileImage = SessionHelper.ProfileImage;
                    if (string.IsNullOrEmpty(profileImage))
                    {
                        var userLogic = new IndustrialSparePartPortal.App_Code.Logic.UserLogic();
                        var ds = userLogic.getUserById(SessionHelper.UserId.Value);
                        if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        {
                            var row = ds.Tables[0].Rows[0];
                            if (row.Table.Columns.Contains("ProfileImage") && row["ProfileImage"] != DBNull.Value)
                            {
                                profileImage = row["ProfileImage"].ToString();
                                SessionHelper.ProfileImage = profileImage;
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(profileImage))
                    {
                        imgAdminAvatar.ImageUrl = ResolveUrl(profileImage);
                        imgAdminAvatar.Visible = true;
                        lblAdminInitials.Visible = false;
                    }
                    else
                    {
                        imgAdminAvatar.Visible = false;
                        lblAdminInitials.Visible = true;
                        string name = SessionHelper.FullName ?? "Administrator";
                        string[] parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                        lblAdminInitials.InnerText = parts.Length >= 2 
                            ? $"{parts[0][0]}{parts[1][0]}".ToUpper() 
                            : (name.Length >= 2 ? name.Substring(0, 2).ToUpper() : "SA");
                    }
                }
            }
        }
    }
}
