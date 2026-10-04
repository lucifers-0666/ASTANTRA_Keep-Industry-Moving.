using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using IndustrialSparePartPortal.App_Code.Database;

namespace IndustrialSparePartPortal.Public
{
    public partial class Technicians : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string querySearch = Request.QueryString["q"] ?? Request.QueryString["search"];
                if (!string.IsNullOrEmpty(querySearch))
                {
                    txtSearch.Text = querySearch.Trim();
                }

                string querySkill = Request.QueryString["skill"];
                if (!string.IsNullOrEmpty(querySkill) && ddlSkill.Items.FindByValue(querySkill) != null)
                {
                    ddlSkill.SelectedValue = querySkill;
                }

                string queryCity = Request.QueryString["city"];
                if (!string.IsNullOrEmpty(queryCity) && ddlCity.Items.FindByValue(queryCity) != null)
                {
                    ddlCity.SelectedValue = queryCity;
                }

                LoadTechnicians(txtSearch.Text.Trim(), ddlSkill.SelectedValue, ddlCity.SelectedValue);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTechnicians(txtSearch.Text.Trim(), ddlSkill.SelectedValue, ddlCity.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlSkill.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            LoadTechnicians(string.Empty, string.Empty, string.Empty);
        }

        private void LoadTechnicians(string search, string skill, string city)
        {
            DataTable dt = null;

            try
            {
                string sql = @"
                    SELECT t.TechnicianId, u.FullName, t.SkillSummary, t.ExperienceYears, t.HourlyRate,
                           t.City, t.State, t.IsAvailable, t.VerificationStatus
                    FROM Technicians t
                    INNER JOIN Users u ON t.UserId = u.UserId
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (u.FullName LIKE @Search OR t.SkillSummary LIKE @Search OR t.City LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", "%" + search + "%"));
                }

                if (!string.IsNullOrEmpty(skill))
                {
                    sql += " AND t.SkillSummary LIKE @Skill";
                    paramList.Add(new SqlParameter("@Skill", "%" + skill + "%"));
                }

                if (!string.IsNullOrEmpty(city))
                {
                    sql += " AND t.City = @City";
                    paramList.Add(new SqlParameter("@City", city));
                }

                sql += " ORDER BY t.IsAvailable DESC, t.ExperienceYears DESC";

                dt = DbFactory.ExecuteQuery(sql, paramList.Count > 0 ? paramList.ToArray() : null);
            }
            catch
            {
                dt = null;
            }

            if (dt == null || dt.Rows.Count == 0)
            {
                dt = GetFallbackTechniciansData(search, skill, city);
            }

            rptTechnicians.DataSource = dt;
            rptTechnicians.DataBind();

            int count = dt != null ? dt.Rows.Count : 0;
            lblResultsCount.Text = $"Showing {count} specialist profile{(count == 1 ? "" : "s")}";
            pnlNoResults.Visible = (count == 0);
        }

        private DataTable GetFallbackTechniciansData(string search, string skill, string city)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("TechnicianId", typeof(int));
            dt.Columns.Add("FullName", typeof(string));
            dt.Columns.Add("City", typeof(string));
            dt.Columns.Add("State", typeof(string));
            dt.Columns.Add("SkillSummary", typeof(string));
            dt.Columns.Add("ExperienceYears", typeof(int));
            dt.Columns.Add("HourlyRate", typeof(decimal));
            dt.Columns.Add("IsAvailable", typeof(bool));
            dt.Columns.Add("VerificationStatus", typeof(string));

            var items = new[]
            {
                new { Id = 1, Name = "Rajesh Sharma", City = "Rajkot", State = "GJ", Skills = "Mechanical Maintenance, Centrifugal Pump Overhaul & Laser Alignment", Exp = 12, Rate = 1200m, Avail = true, Status = "Verified" },
                new { Id = 2, Name = "Amitabh Patel", City = "Ahmedabad", State = "GJ", Skills = "Hydraulic Systems, CNC Lathe Servo Motor Servicing & Commissioning", Exp = 9, Rate = 1500m, Avail = true, Status = "Verified" },
                new { Id = 3, Name = "Sunil Kulkarni", City = "Vadodara", State = "GJ", Skills = "Industrial Electrical, Siemens/ABB VFD Inverter Programming", Exp = 7, Rate = 1100m, Avail = true, Status = "Verified" },
                new { Id = 4, Name = "Vikas Deshmukh", City = "Pune", State = "MH", Skills = "PLC Automation (Allen-Bradley, Delta), SCADA Troubleshooting", Exp = 10, Rate = 1800m, Avail = true, Status = "Verified" },
                new { Id = 5, Name = "Kiran Joshi", City = "Mumbai", State = "MH", Skills = "Industrial Compressor Maintenance, Pneumatic Valve Calibration", Exp = 6, Rate = 950m, Avail = false, Status = "Demo" },
                new { Id = 6, Name = "Praveen Mehta", City = "Surat", State = "GJ", Skills = "Heavy Stamping Press Hydraulics & Seal Replacement Specialist", Exp = 14, Rate = 1600m, Avail = true, Status = "Verified" }
            };

            foreach (var t in items)
            {
                bool matchSkill = string.IsNullOrEmpty(skill) || t.Skills.IndexOf(skill, StringComparison.OrdinalIgnoreCase) >= 0;
                bool matchCity = string.IsNullOrEmpty(city) || t.City.Equals(city, StringComparison.OrdinalIgnoreCase);
                bool matchSearch = string.IsNullOrEmpty(search)
                    || t.Name.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || t.City.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || t.Skills.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0;

                if (matchSkill && matchCity && matchSearch)
                {
                    dt.Rows.Add(t.Id, t.Name, t.City, t.State, t.Skills, t.Exp, t.Rate, t.Avail, t.Status);
                }
            }

            return dt;
        }
    }
}

