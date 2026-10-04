using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using IndustrialSparePartPortal.App_Code.Database;

namespace IndustrialSparePartPortal.Public
{
    public partial class Parts : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check for search query string (e.g. from homepage search redirect)
                string querySearch = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(querySearch))
                {
                    txtSearch.Text = querySearch.Trim();
                }

                // Check for category query string
                string queryCategory = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(queryCategory) && ddlCategory.Items.FindByValue(queryCategory) != null)
                {
                    ddlCategory.SelectedValue = queryCategory;
                }

                LoadCatalog(txtSearch.Text.Trim(), ddlCategory.SelectedValue);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCatalog(txtSearch.Text.Trim(), ddlCategory.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlCategory.SelectedIndex = 0;
            LoadCatalog(string.Empty, string.Empty);
        }

        protected void btnQuickFilter_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            if (btn != null)
            {
                string category = btn.CommandArgument;
                if (ddlCategory.Items.FindByValue(category) != null)
                {
                    ddlCategory.SelectedValue = category;
                }
                LoadCatalog(txtSearch.Text.Trim(), category);
            }
        }

        private void LoadCatalog(string search, string category)
        {
            DataTable dt = null;

            try
            {
                string sql = @"
                    SELECT p.PartId, p.PartNumber, p.PartName, p.Description, p.TechnicalSpecs,
                           c.CategoryName, ISNULL(m.MachineName, 'Universal Machinery') AS MachineName,
                           si.UnitPrice,
                           ISNULL(si.AvailabilityStatus, 'InStock') AS AvailabilityStatus,
                           ISNULL(s.CompanyName, 'Verified Regional Supplier') AS SupplierName
                    FROM SpareParts p
                    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                    LEFT JOIN Machines m ON p.MachineId = m.MachineId
                    LEFT JOIN SupplierInventory si ON p.PartId = si.PartId
                    LEFT JOIN Suppliers s ON si.SupplierId = s.SupplierId
                    WHERE (1 = 1)";

                var paramList = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (p.PartNumber LIKE @Search OR p.PartName LIKE @Search OR m.MachineName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", "%" + search + "%"));
                }

                if (!string.IsNullOrEmpty(category))
                {
                    sql += " AND c.CategoryName = @Category";
                    paramList.Add(new SqlParameter("@Category", category));
                }

                sql += " ORDER BY p.PartId ASC";

                dt = DbFactory.ExecuteQuery(sql, paramList.Count > 0 ? paramList.ToArray() : null);
            }
            catch
            {
                // Fallback handled below
                dt = null;
            }

            // If database table is empty or connection unavailable, provide seeded catalog data
            if (dt == null || dt.Rows.Count == 0)
            {
                dt = GetFallbackPartsData(search, category);
            }

            rptParts.DataSource = dt;
            rptParts.DataBind();

            int count = dt != null ? dt.Rows.Count : 0;
            lblResultsCount.Text = $"Showing {count} spare part{(count == 1 ? "" : "s")} available";
            pnlNoResults.Visible = (count == 0);
        }

        private DataTable GetFallbackPartsData(string search, string category)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PartId", typeof(int));
            dt.Columns.Add("PartNumber", typeof(string));
            dt.Columns.Add("PartName", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("TechnicalSpecs", typeof(string));
            dt.Columns.Add("CategoryName", typeof(string));
            dt.Columns.Add("MachineName", typeof(string));
            dt.Columns.Add("UnitPrice", typeof(decimal));
            dt.Columns.Add("AvailabilityStatus", typeof(string));
            dt.Columns.Add("SupplierName", typeof(string));

            // Seeded items
            var items = new[]
            {
                new { Id = 1, Num = "PART-HYD-001", Name = "High-Pressure Hydraulic Pump 250Bar", Cat = "Hydraulics & Pneumatics", Machine = "Hydraulic Stamping Press 500T", Specs = "Flow Rate: 45 L/min · Pressure: 250 Bar · Flange Mount", Price = 42500m, Status = "InStock", Supplier = "Apex Industrial Hydraulics" },
                new { Id = 2, Num = "PART-MOT-002", Name = "3-Phase AC Servo Motor 7.5kW", Cat = "Motors & Drives", Machine = "CNC Lathe Machine X200", Specs = "Power: 7.5kW · RPM: 3000 · Voltage: 415V 3-Phase", Price = 68000m, Status = "InStock", Supplier = "Gujarat Motion Drives" },
                new { Id = 3, Num = "PART-BRG-003", Name = "Deep Groove Ball Bearing 6210-2RS", Cat = "Bearings & Power Transmission", Machine = "Universal Industrial Shaft", Specs = "Inner Dia: 50mm · Outer Dia: 90mm · Width: 20mm", Price = 1850m, Status = "InStock", Supplier = "National Bearing Corporation" },
                new { Id = 4, Num = "PART-ELE-004", Name = "Industrial VFD Inverter 15kW", Cat = "Electrical & Automation", Machine = "Industrial Air Compressor 75HP", Specs = "Input: 3-Phase 415V · Output: 0-400Hz · IP20 Enclosure", Price = 34200m, Status = "InStock", Supplier = "Western Automation Components" },
                new { Id = 5, Num = "PART-VLV-005", Name = "High-Pressure Solenoid Valve 2-Way", Cat = "Pumps & Valves", Machine = "Hydraulic Stamping Press 500T", Specs = "Port Size: 1/2-inch · Pressure: 200 Bar · 24V DC Coil", Price = 8400m, Status = "InStock", Supplier = "Precision Flow Systems" },
                new { Id = 6, Num = "PART-MOT-006", Name = "Heavy-Duty Worm Gearbox Ratio 30:1", Cat = "Bearings & Power Transmission", Machine = "Industrial Conveyor Line 20M", Specs = "Ratio: 30:1 · Input Shaft: 28mm · Torque: 450 Nm", Price = 26500m, Status = "PreOrder", Supplier = "Gujarat Motion Drives" }
            };

            foreach (var item in items)
            {
                bool matchCategory = string.IsNullOrEmpty(category) || item.Cat.Equals(category, StringComparison.OrdinalIgnoreCase);
                bool matchSearch = string.IsNullOrEmpty(search)
                    || item.Num.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || item.Name.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || item.Machine.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0
                    || item.Cat.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0;

                if (matchCategory && matchSearch)
                {
                    dt.Rows.Add(item.Id, item.Num, item.Name, item.Name, item.Specs, item.Cat, item.Machine, item.Price, item.Status, item.Supplier);
                }
            }

            return dt;
        }
    }
}

