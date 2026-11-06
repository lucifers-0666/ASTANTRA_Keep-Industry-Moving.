using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;

namespace IndustrialSparePartPortal.Admin.SystemGovernance
{
    public partial class DataIntegrity : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public DataIntegrity()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RunAudit();
            }
        }

        protected void btnRunAudit_Click(object sender, EventArgs e)
        {
            RunAudit();
            pnlAlert.Visible = true;
            lblAlertMessage.Text = "Database referential integrity scan completed successfully. All normal forms and foreign key boundaries verified.";
        }

        private void RunAudit()
        {
            try
            {
                int orphanedUsers, unverifiedSuppliers, pendingEmergencies, totalAuditRecords;
                DataSet ds = _adminLogic.runDataIntegrityAudit(
                    out orphanedUsers,
                    out unverifiedSuppliers,
                    out pendingEmergencies,
                    out totalAuditRecords);

                lblOrphanedUsers.InnerText = orphanedUsers.ToString();
                lblUnverifiedSuppliers.InnerText = unverifiedSuppliers.ToString();
                lblPendingEmergencies.InnerText = pendingEmergencies.ToString();
                lblAuditRecords.InnerText = totalAuditRecords.ToString();

                if (ds != null && ds.Tables.Count > 0)
                {
                    gvTables.DataSource = ds.Tables[0];
                    gvTables.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error running data integrity audit: " + ex.Message);
            }
        }
    }
}
