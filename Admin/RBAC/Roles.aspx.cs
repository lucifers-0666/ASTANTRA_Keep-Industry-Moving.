using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.RBAC
{
    public partial class Roles : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public Roles()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();
            }
        }

        private void LoadRoles()
        {
            try
            {
                DataSet ds = _adminLogic.selectAllRoles();
                if (ds != null && ds.Tables.Count > 0)
                {
                    gvRoles.DataSource = ds.Tables[0];
                    gvRoles.DataBind();
                    lblRolesCount.Text = ds.Tables[0].Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading roles: " + ex.Message);
            }
        }
    }
}

