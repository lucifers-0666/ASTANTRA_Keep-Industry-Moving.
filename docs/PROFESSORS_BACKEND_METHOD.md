# ASTANTRA — Professor's ADO.NET Coding Method Reference Sheet
**Deliverable for Phase 2**  
**Project:** ASTANTRA — Keep Industry Moving  
**Target:** Final-Year MCA Academic Viva Standard  
**Lead / Coordinator:** Zaid Amreliya  

> **College Backend Rule Reminder:** The professor does not allow AI-written backend code. Use this reference sheet to understand the exact C# ADO.NET patterns taught in class, and write your code-behind implementations yourself using these patterns.

---

## 1. Central Connection Provider (`DbFactory.cs`)

All database connections should be obtained using `DbFactory.GetConnection()`:

```csharp
using System.Data;
using System.Data.SqlClient;
using IndustrialSparePartPortal.App_Code.Database;

// Pattern:
using (SqlConnection conn = DbFactory.GetConnection())
{
    conn.Open();
    // Execute command here
}
```

---

## 2. Pattern 1: `SELECT` (Fill a `DataTable` for `GridView` or `Repeater`)

Use this when populating tables, order histories, quotation lists, or catalog grids:

```csharp
private void LoadQuotationRequests(int factoryId)
{
    string query = @"
        SELECT q.RfqId, p.PartNumber, p.PartName, q.Quantity, q.TargetPrice, 
               q.Status, q.CreatedAt,
               (SELECT COUNT(*) FROM QuotationResponses r WHERE r.RfqId = q.RfqId) AS BidCount
        FROM QuotationRequests q
        INNER JOIN SpareParts p ON q.PartId = p.PartId
        WHERE q.FactoryId = @FactoryId
        ORDER BY q.CreatedAt DESC";

    using (SqlConnection conn = DbFactory.GetConnection())
    {
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRequests.DataSource = dt;
                gvRequests.DataBind();
            }
        }
    }
}
```

---

## 3. Pattern 2: `SELECT` Single Row (Reading Record Details)

Use this when reading a single user, single part details, or factory profile:

```csharp
private void LoadPartDetails(int partId)
{
    string query = @"
        SELECT PartId, PartNumber, PartName, Description, TechnicalSpecs, UnitOfMeasure
        FROM SpareParts
        WHERE PartId = @PartId";

    using (SqlConnection conn = DbFactory.GetConnection())
    {
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
            conn.Open();

            using (SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow))
            {
                if (reader.Read())
                {
                    lblPartNumber.Text = reader["PartNumber"].ToString();
                    lblPartName.Text = reader["PartName"].ToString();
                    lblSpecs.Text = reader["TechnicalSpecs"] != DBNull.Value ? reader["TechnicalSpecs"].ToString() : "N/A";
                }
            }
        }
    }
}
```

---

## 4. Pattern 3: `INSERT` with `SCOPE_IDENTITY()` (Create Record & Return New ID)

Use this when a factory creates an RFQ or emergency request and you need the generated ID:

```csharp
protected void btnSubmitRfq_Click(object sender, EventArgs e)
{
    string insertSql = @"
        INSERT INTO QuotationRequests (FactoryId, PartId, Quantity, TargetPrice, RequiredByDate, Status, Remarks, CreatedAt)
        VALUES (@FactoryId, @PartId, @Quantity, @TargetPrice, @RequiredByDate, 'Pending', @Remarks, GETDATE());
        SELECT SCOPE_IDENTITY();";

    try
    {
        using (SqlConnection conn = DbFactory.GetConnection())
        {
            using (SqlCommand cmd = new SqlCommand(insertSql, conn))
            {
                cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = SessionHelper.UserId.Value });
                cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = Convert.ToInt32(ddlParts.SelectedValue) });
                cmd.Parameters.Add(new SqlParameter("@Quantity", SqlDbType.Int) { Value = Convert.ToInt32(txtQuantity.Text.Trim()) });
                cmd.Parameters.Add(new SqlParameter("@TargetPrice", SqlDbType.Decimal) { 
                    Value = string.IsNullOrEmpty(txtTargetPrice.Text) ? (object)DBNull.Value : Convert.ToDecimal(txtTargetPrice.Text.Trim()) 
                });
                cmd.Parameters.Add(new SqlParameter("@RequiredByDate", SqlDbType.Date) { 
                    Value = string.IsNullOrEmpty(txtRequiredDate.Text) ? (object)DBNull.Value : Convert.ToDateTime(txtRequiredDate.Text.Trim()) 
                });
                cmd.Parameters.Add(new SqlParameter("@Remarks", SqlDbType.NVarChar, -1) { 
                    Value = string.IsNullOrEmpty(txtRemarks.Text) ? (object)DBNull.Value : txtRemarks.Text.Trim() 
                });

                conn.Open();
                object newId = cmd.ExecuteScalar();
                int generatedRfqId = Convert.ToInt32(newId);

                pnlSuccess.Visible = true;
                lblSuccessMessage.Text = $"Quotation Request RFQ-{generatedRfqId:D5} submitted successfully!";
            }
        }
    }
    catch (SqlException ex)
    {
        pnlError.Visible = true;
        lblErrorMessage.Text = "Database operation failed: " + ex.Message;
    }
}
```

---

## 5. Pattern 4: `UPDATE` (Updating Record Status)

Use this when updating user active status, approving suppliers, or updating order status:

```csharp
private bool UpdateUserActiveStatus(int userId, bool isActive)
{
    string updateSql = @"
        UPDATE Users 
        SET IsActive = @IsActive, UpdatedAt = GETDATE()
        WHERE UserId = @UserId";

    using (SqlConnection conn = DbFactory.GetConnection())
    {
        using (SqlCommand cmd = new SqlCommand(updateSql, conn))
        {
            cmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
            cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });

            conn.Open();
            int rowsAffected = cmd.ExecuteNonQuery();
            return rowsAffected > 0;
        }
    }
}
```

---

## 6. Pattern 5: Multi-Table Transaction (`SqlTransaction`)

Use this when accepting a supplier bid (updating `QuotationRequests.Status` to 'Accepted', `QuotationResponses.Status` to 'Accepted', and creating a new record in `Orders`):

```csharp
private bool AcceptSupplierBid(int rfqId, int responseId, int factoryId, int supplierId, decimal totalAmount)
{
    using (SqlConnection conn = DbFactory.GetConnection())
    {
        conn.Open();
        SqlTransaction transaction = conn.BeginTransaction();

        try
        {
            // 1. Update accepted response
            string sqlResponse = "UPDATE QuotationResponses SET Status = 'Accepted' WHERE ResponseId = @ResponseId";
            using (SqlCommand cmd = new SqlCommand(sqlResponse, conn, transaction))
            {
                cmd.Parameters.Add(new SqlParameter("@ResponseId", SqlDbType.Int) { Value = responseId });
                cmd.ExecuteNonQuery();
            }

            // 2. Close RFQ
            string sqlRfq = "UPDATE QuotationRequests SET Status = 'Closed' WHERE RfqId = @RfqId";
            using (SqlCommand cmd = new SqlCommand(sqlRfq, conn, transaction))
            {
                cmd.Parameters.Add(new SqlParameter("@RfqId", SqlDbType.Int) { Value = rfqId });
                cmd.ExecuteNonQuery();
            }

            // 3. Create procurement order
            string sqlOrder = @"
                INSERT INTO Orders (OrderNumber, FactoryId, SupplierId, TotalAmount, OrderStatus, IsEmergency, OrderDate)
                VALUES (@OrderNumber, @FactoryId, @SupplierId, @TotalAmount, 'Placed', 0, GETDATE())";
            using (SqlCommand cmd = new SqlCommand(sqlOrder, conn, transaction))
            {
                string orderNumber = "ORD-" + DateTime.Now.ToString("yyyyMMdd") + "-" + rfqId;
                cmd.Parameters.Add(new SqlParameter("@OrderNumber", SqlDbType.VarChar, 50) { Value = orderNumber });
                cmd.Parameters.Add(new SqlParameter("@FactoryId", SqlDbType.Int) { Value = factoryId });
                cmd.Parameters.Add(new SqlParameter("@SupplierId", SqlDbType.Int) { Value = supplierId });
                cmd.Parameters.Add(new SqlParameter("@TotalAmount", SqlDbType.Decimal) { Value = totalAmount });
                cmd.ExecuteNonQuery();
            }

            transaction.Commit();
            return true;
        }
        catch (Exception)
        {
            transaction.Rollback();
            throw;
        }
    }
}
```

---

## 7. Viva Explanations for ADO.NET Code

When the examiner asks:
- **Q: Why use ADO.NET instead of Entity Framework?**
  *A: Parameterized ADO.NET offers direct control over SQL query performance, guarantees complete transparency against SQL injection vulnerabilities without hidden ORM overhead, and ensures academic explainability where every query execution cycle is clear.*
- **Q: Why are `using` blocks mandatory?**
  *A: `SqlConnection`, `SqlCommand`, and `SqlDataReader` implement `IDisposable`. Wrapping them in `using` ensures unmanaged database resources and connection pool sockets are immediately closed and released even if an unhandled exception occurs.*
- **Q: Why use `SqlParameter` instead of string concatenation?**
  *A: String concatenation like `"' + txtUser.Text + "'"` makes the system vulnerable to SQL injection attacks (e.g. `' OR 1=1 --`). `SqlParameter` treats user input strictly as literal values rather than executable SQL code, and also aids SQL Server execution plan caching.*

