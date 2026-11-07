using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Helpers;
using IndustrialSparePartPortal.App_Code.Logic;
using System;

namespace IndustrialSparePartPortal.Admin.SystemGovernance
{
    public partial class SystemHealth : BasePage
    {
        private readonly AdminLogic _adminLogic = new AdminLogic();

        public SystemHealth()
        {
            RequiredRole = RoleConstants.Administrator;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHealthTelemetry();
            }
        }

        protected void btnTestDb_Click(object sender, EventArgs e)
        {
            try
            {
                string sqlVersion;
                int totalTables, totalDbRows;
                bool isOperational;
                long latencyMs;

                _adminLogic.getSystemHealthMetrics(out sqlVersion, out totalTables, out totalDbRows, out isOperational, out latencyMs);
                LoadHealthTelemetry();

                pnlAlert.Visible = true;
                if (isOperational)
                {
                    lblAlertMessage.Text = $"Live database ping test successful: Query engine round-trip latency measured at {latencyMs}ms across {totalTables} system tables and {totalDbRows:N0} live rows. LocalDB transaction pipeline verified operational.";
                }
                else
                {
                    lblAlertMessage.Text = "Database connection test failed. SQL Server engine unresponsive.";
                }
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = AppErrorHandler.FormatSafeErrorMessage(ex, "Database connection ping test encountered an error");
            }
        }

        private void LoadHealthTelemetry()
        {
            try
            {
                string sqlVersion;
                int totalTables, totalDbRows;
                bool isOperational;
                long latencyMs;

                _adminLogic.getSystemHealthMetrics(out sqlVersion, out totalTables, out totalDbRows, out isOperational, out latencyMs);

                lblTotalTables.InnerText = totalTables.ToString();
                lblTotalRows.InnerText = totalDbRows.ToString("N0");
                lblSqlVersion.InnerText = sqlVersion;
                lblClrVersion.InnerText = Environment.Version.ToString();
                lblMachineName.InnerText = Environment.MachineName;
            }
            catch (Exception ex)
            {
                pnlAlert.Visible = true;
                lblAlertMessage.Text = AppErrorHandler.FormatSafeErrorMessage(ex, "Failed to load system runtime telemetry");
            }
        }
    }
}
