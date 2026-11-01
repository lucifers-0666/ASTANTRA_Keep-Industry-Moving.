using System;
using System.Configuration;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Logic
{
    /// <summary>
    /// Base class for Three-Tier Database Logic Layer.
    /// Provides central SQL connection initialization via getcon().
    /// </summary>
    public class BaseLogic
    {
        protected static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["IndustrialSparePartDB"] != null
            ? ConfigurationManager.ConnectionStrings["IndustrialSparePartDB"].ConnectionString
            : "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=IndustrialSparePartDB;Integrated Security=True;TrustServerCertificate=True;";

        /// <summary>
        /// Creates and opens a new SQL Server database connection.
        /// </summary>
        public SqlConnection getcon()
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            con.Open();
            return con;
        }
    }
}

