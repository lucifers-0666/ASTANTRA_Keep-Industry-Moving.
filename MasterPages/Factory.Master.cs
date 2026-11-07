using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace IndustrialSparePartPortal.MasterPages
{
    public partial class FactoryMaster : MasterPage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly FactoryProfileLogic _profileLogic = new FactoryProfileLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!SessionHelper.IsLoggedIn || !string.Equals(SessionHelper.UserRole, RoleConstants.Factory, StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Account/AccessDenied.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                LoadFactoryIdentity();
                HighlightActiveNav();
            }
        }

        private void LoadFactoryIdentity()
        {
            int? userId = SessionHelper.UserId;
            if (userId.HasValue)
            {
                int factoryId = _userLogic.resolveFactoryId(userId.Value);
                if (factoryId > 0)
                {
                    DataRow profile = _profileLogic.getFactoryProfile(factoryId);
                    if (profile != null)
                    {
                        lblFactoryName.InnerText = profile["CompanyName"].ToString();
                        string city = profile["City"] != DBNull.Value ? profile["City"].ToString() : "Regional Plant";
                        string state = profile["State"] != DBNull.Value ? profile["State"].ToString() : "";
                        lblFactoryLocation.InnerText = !string.IsNullOrEmpty(state) ? string.Format("{0}, {1}", city, state) : city;
                        return;
                    }
                }
            }

            lblFactoryName.InnerText = SessionHelper.FullName ?? "Industrial Buyer";
            lblFactoryLocation.InnerText = "Operational Facility";
        }

        private void HighlightActiveNav()
        {
            string path = Request.AppRelativeCurrentExecutionFilePath.ToLowerInvariant();

            SetNavState(navDashboard, path.Contains("/dashboard.aspx"));
            SetNavState(navSearch, path.Contains("/spareparts/search.aspx"));
            SetNavState(navRfqs, path.Contains("/quotations/myrequests.aspx") || path.Contains("/quotations/compare.aspx"));
            SetNavState(navOrders, path.Contains("/orders/"));
            SetNavState(navMachinery, path.Contains("/machines/"));
            SetNavState(navTechnicians, path.Contains("/technicians/"));
        }

        private void SetNavState(HtmlAnchor link, bool isActive)
        {
            if (link != null)
            {
                if (isActive)
                {
                    link.Attributes["class"] = "factory-nav-link active";
                }
                else
                {
                    link.Attributes["class"] = "factory-nav-link";
                }
            }
        }
    }
}
