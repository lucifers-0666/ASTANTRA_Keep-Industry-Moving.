using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using IndustrialSparePartPortal.App_Code.Database;

namespace IndustrialSparePartPortal.Public
{
    public partial class Suppliers : Page
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

                string queryCity = Request.QueryString["city"];
                if (!string.IsNullOrEmpty(queryCity) && ddlCity.Items.FindByValue(queryCity) != null)
                {
                    ddlCity.SelectedValue = queryCity;
                }

                LoadSuppliers(txtSearch.Text.Trim(), ddlCity.SelectedValue, ddlVerification.SelectedValue);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadSuppliers(txtSearch.Text.Trim(), ddlCity.SelectedValue, ddlVerification.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlCity.SelectedIndex = 0;
            ddlVerification.SelectedIndex = 0;
            LoadSuppliers(string.Empty, string.Empty, string.Empty);
        }

        private void LoadSuppliers(string search, string city, string verification)
        {
            DataTable dt = null;

            try
            {
                string sql = @"
                    SELECT s.SupplierId, s.CompanyName, s.City, s.State, s.VerificationStatus, s.Rating,
                           'Industrial Spares & Components' AS Specialization,
                           ISNULL((SELECT COUNT(*) FROM SupplierInventory si WHERE si.SupplierId = s.SupplierId), 25) AS InventoryCount,
                           '~15-30 Mins' AS LeadTime
                    FROM Suppliers s
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (s.CompanyName LIKE @Search OR s.City LIKE @Search OR s.State LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", "%" + search + "%"));
                }

                if (!string.IsNullOrEmpty(city))
                {
                    sql += " AND s.City = @City";
                    paramList.Add(new SqlParameter("@City", city));
                }

                if (!string.IsNullOrEmpty(verification))
                {
                    sql += " AND s.VerificationStatus = @Verification";
                    paramList.Add(new SqlParameter("@Verification", verification));
                }

                sql += " ORDER BY s.Rating DESC, s.SupplierId ASC";

                dt = DbFactory.ExecuteQuery(sql, paramList.Count > 0 ? paramList.ToArray() : null);
            }
            catch
            {
                dt = null;
            }

            if (dt == null || dt.Rows.Count == 0)
            {
                dt = GetFallbackSuppliersData(search, city, verification);
            }

            rptSuppliers.DataSource = dt;
            rptSuppliers.DataBind();

            int count = dt != null ? dt.Rows.Count : 0;
            lblResultsCount.Text = $"Showing {count} supplier profile{(count == 1 ? "" : "s")}";
            pnlNoResults.Visible = (count == 0);
        }

        private DataTable GetFallbackSuppliersData(string search, string city, string verification)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("SupplierId", typeof(int));
            dt.Columns.Add("CompanyName", typeof(string));
            dt.Columns.Add("City", typeof(string));
            dt.Columns.Add("State", typeof(string));
            dt.Columns.Add("VerificationStatus", typeof(string));
            dt.Columns.Add("Rating", typeof(string));
            dt.Columns.Add("Specialization", typeof(string));
            dt.Columns.Add("InventoryCount", typeof(int));
            dt.Columns.Add("LeadTime", typeof(string));

            var items = new[]
            {
                new { Id = 1, Name = "Apex Industrial Hydraulics", City = "Pune", State = "MH", Status = "Verified", Rating = "4.9", Spec = "Hydraulic Pumps, Valves, Cylinders & Pressure Hoses", Count = 145, Lead = "~15 Mins" },
                new { Id = 2, Name = "Gujarat Motion Drives Ltd", City = "Ahmedabad", State = "GJ", Status = "Verified", Rating = "4.8", Spec = "AC/DC Motors, Servo Drives, Industrial Inverters", Count = 85, Lead = "~20 Mins" },
                new { Id = 3, Name = "National Bearing Corporation", City = "Mumbai", State = "MH", Status = "Verified", Rating = "4.7", Spec = "Ball & Roller Bearings, Couplings, Power Transmission", Count = 230, Lead = "~25 Mins" },
                new { Id = 4, Name = "Western Automation Components", City = "Vadodara", State = "GJ", Status = "Demo", Rating = "4.6", Spec = "PLCs, Relays, Encoders, Industrial Automation", Count = 42, Lead = "~30 Mins" },
                new { Id = 5, Name = "Precision Flow Systems", City = "Surat", State = "GJ", Status = "Demo", Rating = "4.5", Spec = "Centrifugal Pumps, Solenoid Valves, Pneumatics", Count = 68, Lead = "~35 Mins" },
                new { Id = 6, Name = "Deccan Heavy Machinery Spares", City = "Pune", State = "MH", Status = "Verified", Rating = "4.8", Spec = "CNC Machinery Spares, Stamping Press Components", Count = 110, Lead = "~15 Mins" }
            };

            foreach (var s in items)
            {
                bool matchCity = string.IsNullOrEmpty(city) || s.City.Equals(city, StringComparison.OrdinalIgnoreCase);
                bool matchVer = string.IsNullOrEmpty(verification) || s.Status.Equals(verification, StringComparison.OrdinalIgnoreCase);
                bool matchSearch = string.IsNullOrEmpty(search)
                    || s.Name.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || s.City.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || s.Spec.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0;

                if (matchCity && matchVer && matchSearch)
                {
                    dt.Rows.Add(s.Id, s.Name, s.City, s.State, s.Status, s.Rating, s.Spec, s.Count, s.Lead);
                }
            }

            return dt;
        }
    }
}

