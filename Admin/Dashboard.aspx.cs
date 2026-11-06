using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin
{
    public partial class Dashboard : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public Dashboard()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                // 1. Load Executive KPIs via AdminLogic
                int totalUsers, verifiedSuppliers, activeFactories, activeTechnicians, openEmergencies, pendingRfqs, totalOrders;
                decimal totalGmv;

                _adminLogic.getExecutiveKpis(
                    out totalUsers,
                    out verifiedSuppliers,
                    out activeFactories,
                    out activeTechnicians,
                    out openEmergencies,
                    out pendingRfqs,
                    out totalOrders,
                    out totalGmv
                );

                lblTotalUsers.InnerText = totalUsers.ToString();
                lblVerifiedSuppliers.InnerText = verifiedSuppliers.ToString();
                lblActiveFactories.InnerText = activeFactories.ToString();
                lblActiveTechnicians.InnerText = activeTechnicians.ToString();
                lblActiveEmergency.InnerText = openEmergencies.ToString();
                lblOpenRfqs.InnerText = pendingRfqs.ToString();
                lblTotalOrders.InnerText = totalOrders.ToString();
                lblTotalGmv.InnerText = string.Format("₹{0:N0}", totalGmv);

                // 2. Load Active Emergencies
                DataSet dsEmergencies = _adminLogic.selectOpenEmergencies();
                if (dsEmergencies != null && dsEmergencies.Tables.Count > 0)
                {
                    gvEmergencies.DataSource = dsEmergencies.Tables[0];
                    gvEmergencies.DataBind();
                }

                // 3. Load Recent Registered Users (Limit to 8 on dashboard)
                DataSet dsUsers = _userLogic.selectAllUsers();
                if (dsUsers != null && dsUsers.Tables.Count > 0)
                {
                    DataTable dt = dsUsers.Tables[0];
                    if (dt.Rows.Count > 8)
                    {
                        DataTable dtTop = dt.Clone();
                        for (int i = 0; i < 8; i++)
                        {
                            dtTop.ImportRow(dt.Rows[i]);
                        }
                        gvUsers.DataSource = dtTop;
                    }
                    else
                    {
                        gvUsers.DataSource = dt;
                    }
                    gvUsers.DataBind();
                }

                // 4. Session info
                if (!string.IsNullOrEmpty(SessionHelper.FullName))
                {
                    lblSessionUser.InnerText = SessionHelper.FullName;
                }
                else
                {
                    lblSessionUser.InnerText = "Platform Superadmin";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in Admin Dashboard Page_Load: " + ex.Message);
            }
        }
    }
}
