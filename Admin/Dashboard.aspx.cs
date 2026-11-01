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
            DataSet dsUsers = _userLogic.selectAllUsers();
            if (dsUsers != null && dsUsers.Tables.Count > 0)
            {
                gvUsers.DataSource = dsUsers.Tables[0];
                gvUsers.DataBind();
                lblTotalUsers.InnerText = dsUsers.Tables[0].Rows.Count.ToString();
            }
            else
            {
                lblTotalUsers.InnerText = "0";
            }
        }
    }
}
