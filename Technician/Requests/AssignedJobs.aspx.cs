using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace IndustrialSparePartPortal.Technician.Requests
{
    public partial class AssignedJobs : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly ServiceLogic _serviceLogic = new ServiceLogic();

        public AssignedJobs()
        {
            RequiredRole = RoleConstants.Technician;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadJobs();
            }
        }

        private int GetTechnicianId()
        {
            if (SessionHelper.UserId == null) return 0;
            return _userLogic.resolveTechnicianId(SessionHelper.UserId.Value);
        }

        private void LoadJobs()
        {
            int technicianId = GetTechnicianId();
            if (technicianId == 0) return;

            string statusFilter = ddlStatusFilter.SelectedValue;
            DataSet ds = _serviceLogic.selectAssignedJobs(technicianId, statusFilter);
            DataTable dt = (ds != null && ds.Tables.Count > 0) ? ds.Tables[0] : null;

            gvJobs.DataSource = dt;
            gvJobs.DataBind();

            lblJobsCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadJobs();
        }

        protected void gvJobs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateJob")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int requestId = Convert.ToInt32(gvJobs.DataKeys[rowIndex].Values["ServiceRequestId"]);
                string factoryName = gvJobs.DataKeys[rowIndex].Values["FactoryName"].ToString();
                string currentStatus = gvJobs.DataKeys[rowIndex].Values["ServiceStatus"].ToString();

                hfSelectedRequestId.Value = requestId.ToString();
                lblCallIdDisp.Text = requestId.ToString();
                lblPlantNameDisp.InnerText = factoryName;

                if (ddlJobStatus.Items.FindByValue(currentStatus) != null)
                {
                    ddlJobStatus.SelectedValue = currentStatus;
                }

                txtDiagnosisNotes.Text = string.Empty;
                pnlUpdateJob.Visible = true;
            }
        }

        protected void btnCancelJob_Click(object sender, EventArgs e)
        {
            pnlUpdateJob.Visible = false;
        }

        protected void btnSaveJobStatus_Click(object sender, EventArgs e)
        {
            int technicianId = GetTechnicianId();
            if (technicianId == 0) return;

            int requestId;
            if (!int.TryParse(hfSelectedRequestId.Value, out requestId))
            {
                ShowAlert("Invalid service call reference.", true);
                return;
            }

            string newStatus = ddlJobStatus.SelectedValue;
            string notes = txtDiagnosisNotes.Text.Trim();

            bool success = _serviceLogic.updateServiceStatus(requestId, technicianId, newStatus, notes);

            if (success)
            {
                pnlUpdateJob.Visible = false;
                ShowAlert($"Service Call #{requestId} status updated to '{newStatus}' successfully!", false);
                LoadJobs();
            }
            else
            {
                ShowAlert("Failed to update service call status.", true);
            }
        }

        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            if (isError)
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#FEE2E2] border border-[#FCA5A5] text-xs text-[#991B1B] flex items-center justify-between";
            }
            else
            {
                pnlAlert.CssClass = "p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between";
            }
            lblAlertMessage.Text = message;
        }
    }
}

