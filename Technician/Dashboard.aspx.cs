using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;

namespace IndustrialSparePartPortal.Technician
{
    public partial class Dashboard : BasePage
    {
        private readonly UserLogic _userLogic = new UserLogic();
        private readonly ServiceLogic _serviceLogic = new ServiceLogic();

        public Dashboard()
        {
            RequiredRole = RoleConstants.Technician;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTechName.InnerText = SessionHelper.FullName ?? "Service Provider";
                LoadTechnicianMetrics();
            }
        }

        private int GetTechnicianId()
        {
            if (SessionHelper.UserId == null) return 0;
            return _userLogic.resolveTechnicianId(SessionHelper.UserId.Value);
        }

        private void LoadTechnicianMetrics()
        {
            int technicianId = GetTechnicianId();
            if (technicianId == 0) return;

            int assignedJobs, completedJobs;
            decimal hourlyRate;
            bool isAvailable;

            _serviceLogic.getTechnicianDashboardMetrics(technicianId, out assignedJobs, out completedJobs, out hourlyRate, out isAvailable);

            lblAssignedJobs.Text = assignedJobs.ToString();
            lblCompletedJobs.Text = completedJobs.ToString();
            lblHourlyRate.Text = $"₹{hourlyRate:N0}/hr";

            if (isAvailable)
            {
                lblDutyStatus.Text = "<span class='text-emerald-600'><i class='fa-solid fa-circle text-[8px] mr-1'></i> On Duty &middot; Available</span>";
                btnToggleAvailability.Text = "Set to Off Duty";
                btnToggleAvailability.CssClass = "btn-secondary text-xs py-2.5 px-4 font-bold text-slate-700 hover:text-slate-900 cursor-pointer";
            }
            else
            {
                lblDutyStatus.Text = "<span class='text-amber-600'><i class='fa-solid fa-circle text-[8px] mr-1'></i> Off Duty &middot; Unavailable</span>";
                btnToggleAvailability.Text = "Set to On Duty";
                btnToggleAvailability.CssClass = "btn-primary text-xs py-2.5 px-4 font-bold bg-[#059669] hover:bg-[#047857] cursor-pointer";
            }
        }

        protected void btnToggleAvailability_Click(object sender, EventArgs e)
        {
            int technicianId = GetTechnicianId();
            if (technicianId == 0) return;

            int assignedJobs, completedJobs;
            decimal hourlyRate;
            bool currentAvailable;

            _serviceLogic.getTechnicianDashboardMetrics(technicianId, out assignedJobs, out completedJobs, out hourlyRate, out currentAvailable);

            bool newAvailable = !currentAvailable;
            bool success = _serviceLogic.updateTechnicianDutyStatus(technicianId, newAvailable);

            if (success)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = $"Duty availability status updated to {(newAvailable ? "On Duty (Available for bookings)" : "Off Duty (Unavailable)")}.";
                LoadTechnicianMetrics();
            }
            else
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = "Failed to update duty availability status.";
            }
        }
    }
}
