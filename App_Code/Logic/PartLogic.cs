using System;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Three-Tier Database Logic class for Spare Parts Master Catalog, Categories, and Machinery.
    /// </summary>
    public class PartLogic : BaseLogic
    {
        public DataSet selectCatalog(string search = null, string category = null, string machine = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT p.PartId, p.PartNumber, p.PartName, p.Description, p.TechnicalSpecs, p.UnitOfMeasure,
                           c.CategoryName, 
                           ISNULL(m.MachineName, 'Universal Machinery') AS MachineName,
                           ISNULL(si.UnitPrice, 0.00) AS UnitPrice,
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
                    sql += " AND (p.PartNumber LIKE @Search OR p.PartName LIKE @Search OR p.TechnicalSpecs LIKE @Search OR m.MachineName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + search + "%" });
                }

                if (!string.IsNullOrEmpty(category))
                {
                    sql += " AND (c.CategoryName = @Category OR c.CategoryId = @CatId)";
                    int catId;
                    int.TryParse(category, out catId);
                    paramList.Add(new SqlParameter("@Category", SqlDbType.NVarChar, 100) { Value = category });
                    paramList.Add(new SqlParameter("@CatId", SqlDbType.Int) { Value = catId });
                }

                if (!string.IsNullOrEmpty(machine))
                {
                    sql += " AND (m.MachineName = @Machine OR m.MachineId = @MacId)";
                    int macId;
                    int.TryParse(machine, out macId);
                    paramList.Add(new SqlParameter("@Machine", SqlDbType.NVarChar, 100) { Value = machine });
                    paramList.Add(new SqlParameter("@MacId", SqlDbType.Int) { Value = macId });
                }

                sql += " ORDER BY p.PartId ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (paramList.Count > 0)
                    {
                        cmd.Parameters.AddRange(paramList.ToArray());
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectCategories()
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT CategoryId, CategoryName, Description, IconClass FROM Categories WHERE IsActive = 1 ORDER BY CategoryName ASC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectMachines()
        {
            using (SqlConnection con = getcon())
            {
                string sql = "SELECT MachineId, MachineName, ModelNumber, Manufacturer FROM Machines ORDER BY MachineName ASC";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectPartById(int partId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT p.PartId, p.CategoryId, p.MachineId, p.PartNumber, p.PartName, 
                           p.Description, p.TechnicalSpecs, p.UnitOfMeasure,
                           c.CategoryName, m.MachineName
                    FROM SpareParts p
                    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                    LEFT JOIN Machines m ON p.MachineId = m.MachineId
                    WHERE p.PartId = @PartId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public DataSet selectAllParts()
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    SELECT p.PartId, p.PartNumber, p.PartName, p.TechnicalSpecs, p.UnitOfMeasure,
                           c.CategoryName, m.MachineName
                    FROM SpareParts p
                    INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                    LEFT JOIN Machines m ON p.MachineId = m.MachineId
                    ORDER BY p.PartId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public int insertPart(int categoryId, int? machineId, string partNumber, string partName, string description, string technicalSpecs, string unitOfMeasure)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO SpareParts (CategoryId, MachineId, PartNumber, PartName, Description, TechnicalSpecs, UnitOfMeasure, CreatedAt)
                    VALUES (@CategoryId, @MachineId, @PartNumber, @PartName, @Description, @TechnicalSpecs, @UnitOfMeasure, GETDATE());
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = categoryId });
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = (object)machineId ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@PartNumber", SqlDbType.VarChar, 100) { Value = partNumber });
                    cmd.Parameters.Add(new SqlParameter("@PartName", SqlDbType.NVarChar, 150) { Value = partName });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)description ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@TechnicalSpecs", SqlDbType.NVarChar, -1) { Value = (object)technicalSpecs ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasure", SqlDbType.NVarChar, 20) { Value = unitOfMeasure ?? "Piece" });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public int insertCategory(string categoryName, string description, string iconClass)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Categories (CategoryName, Description, IconClass, IsActive)
                    VALUES (@CategoryName, @Description, @IconClass, 1);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CategoryName", SqlDbType.NVarChar, 100) { Value = categoryName });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, 255) { Value = (object)description ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@IconClass", SqlDbType.VarChar, 50) { Value = string.IsNullOrEmpty(iconClass) ? "fa-cogs" : iconClass });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public int insertMachine(string machineName, string modelNumber, string manufacturer, string description = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    INSERT INTO Machines (MachineName, ModelNumber, Manufacturer, Description)
                    VALUES (@MachineName, @ModelNumber, @Manufacturer, @Description);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@MachineName", SqlDbType.NVarChar, 150) { Value = machineName });
                    cmd.Parameters.Add(new SqlParameter("@ModelNumber", SqlDbType.NVarChar, 100) { Value = (object)modelNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Manufacturer", SqlDbType.NVarChar, 100) { Value = (object)manufacturer ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)description ?? DBNull.Value });

                    object res = cmd.ExecuteScalar();
                    return Convert.ToInt32(res);
                }
            }
        }

        public bool updatePart(int partId, int categoryId, int? machineId, string partNumber, string partName, string description, string technicalSpecs, string unitOfMeasure)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE SpareParts 
                    SET CategoryId = @CategoryId, 
                        MachineId = @MachineId, 
                        PartNumber = @PartNumber, 
                        PartName = @PartName, 
                        Description = @Description, 
                        TechnicalSpecs = @TechnicalSpecs, 
                        UnitOfMeasure = @UnitOfMeasure
                    WHERE PartId = @PartId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = categoryId });
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = (object)machineId ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@PartNumber", SqlDbType.VarChar, 100) { Value = partNumber });
                    cmd.Parameters.Add(new SqlParameter("@PartName", SqlDbType.NVarChar, 150) { Value = partName });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)description ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@TechnicalSpecs", SqlDbType.NVarChar, -1) { Value = (object)technicalSpecs ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasure", SqlDbType.NVarChar, 20) { Value = unitOfMeasure ?? "Piece" });
                    cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deletePart(int partId)
        {
            using (SqlConnection con = getcon())
            {
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // Remove supplier inventory links
                        string sqlInv = "DELETE FROM SupplierInventory WHERE PartId = @PartId";
                        using (SqlCommand cmd = new SqlCommand(sqlInv, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                            cmd.ExecuteNonQuery();
                        }

                        // Remove from quotation requests if any
                        string sqlQuo = "DELETE FROM QuotationRequests WHERE PartId = @PartId";
                        using (SqlCommand cmd = new SqlCommand(sqlQuo, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                            cmd.ExecuteNonQuery();
                        }

                        string sqlPart = "DELETE FROM SpareParts WHERE PartId = @PartId";
                        using (SqlCommand cmd = new SqlCommand(sqlPart, con, tx))
                        {
                            cmd.Parameters.Add(new SqlParameter("@PartId", SqlDbType.Int) { Value = partId });
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        return true;
                    }
                    catch
                    {
                        tx.Rollback();
                        return false;
                    }
                }
            }
        }

        public bool updateCategory(int categoryId, string categoryName, string description, string iconClass, bool isActive)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Categories 
                    SET CategoryName = @CategoryName, 
                        Description = @Description, 
                        IconClass = @IconClass, 
                        IsActive = @IsActive 
                    WHERE CategoryId = @CategoryId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CategoryName", SqlDbType.NVarChar, 100) { Value = categoryName });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, 255) { Value = (object)description ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@IconClass", SqlDbType.VarChar, 50) { Value = string.IsNullOrEmpty(iconClass) ? "fa-cogs" : iconClass });
                    cmd.Parameters.Add(new SqlParameter("@IsActive", SqlDbType.Bit) { Value = isActive });
                    cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = categoryId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteCategory(int categoryId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "DELETE FROM Categories WHERE CategoryId = @CategoryId AND NOT EXISTS (SELECT 1 FROM SpareParts WHERE CategoryId = @CategoryId)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@CategoryId", SqlDbType.Int) { Value = categoryId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool updateMachine(int machineId, string machineName, string modelNumber, string manufacturer, string description = null)
        {
            using (SqlConnection con = getcon())
            {
                string sql = @"
                    UPDATE Machines 
                    SET MachineName = @MachineName, 
                        ModelNumber = @ModelNumber, 
                        Manufacturer = @Manufacturer, 
                        Description = @Description 
                    WHERE MachineId = @MachineId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@MachineName", SqlDbType.NVarChar, 150) { Value = machineName });
                    cmd.Parameters.Add(new SqlParameter("@ModelNumber", SqlDbType.NVarChar, 100) { Value = (object)modelNumber ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Manufacturer", SqlDbType.NVarChar, 100) { Value = (object)manufacturer ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)description ?? DBNull.Value });
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = machineId });

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public bool deleteMachine(int machineId)
        {
            using (SqlConnection con = getcon())
            {
                string sql = "DELETE FROM Machines WHERE MachineId = @MachineId AND NOT EXISTS (SELECT 1 FROM SpareParts WHERE MachineId = @MachineId)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@MachineId", SqlDbType.Int) { Value = machineId });
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
    }
}

