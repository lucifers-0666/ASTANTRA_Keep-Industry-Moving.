using IndustrialSparePartPortal.App_Code.Constants;
using IndustrialSparePartPortal.App_Code.Logic;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace IndustrialSparePartPortal.App_Code.Helpers
{
    /// <summary>
    /// Specialized Base Page for the Factory Buyer Workspace.
    /// Strictly enforces RoleConstants.Factory authorization, securely resolves the
    /// authenticated FactoryId from server session, and prevents cross-tenant data leakage.
    /// </summary>
    public abstract class FactoryBasePage : BasePage
    {
        private static string GetConnectionString()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["IndustrialDbConn"];
            if (settings != null && !string.IsNullOrEmpty(settings.ConnectionString))
            {
                return settings.ConnectionString;
            }
            return "Server=(localdb)\\MSSQLLocalDB;Database=IndustrialSparePartDB;Integrated Security=True;";
        }

        /// <summary>
        /// Gets the verified, server-resolved Factory ID for the authenticated buyer account.
        /// Never trusted from query strings, form fields, or client-side tokens.
        /// </summary>
        protected int CurrentFactoryId { get; private set; }

        /// <summary>
        /// Gets the official registered company name of the authenticated factory.
        /// </summary>
        protected string CurrentFactoryName { get; private set; }

        /// <summary>
        /// Gets the plant location city of the authenticated factory.
        /// </summary>
        protected string CurrentFactoryCity { get; private set; }

        /// <summary>
        /// Gets whether the factory profile was successfully resolved.
        /// </summary>
        protected bool IsFactoryProfileResolved
        {
            get { return CurrentFactoryId > 0; }
        }

        protected FactoryBasePage()
        {
            RequiredRole = RoleConstants.Factory;
            RequireVerification = false; // Permitted to view profile and configuration
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (!SessionHelper.IsLoggedIn)
            {
                Response.Redirect("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl), true);
                return;
            }

            int? userId = SessionHelper.UserId;
            if (!userId.HasValue)
            {
                Response.Redirect("~/Account/AccessDenied.aspx", true);
                return;
            }

            ResolveFactoryIdentity(userId.Value);

            if (CurrentFactoryId <= 0)
            {
                // User has Factory role, but no row in Factories table exists.
                // Log security alert and redirect to safe configuration or access denied.
                try
                {
                    AuditLogic audit = new AuditLogic();
                    audit.logAction(userId.Value, "FACTORY_IDENTITY_UNRESOLVED", "Factories", null, null,
                        string.Format("Authenticated user {0} (ID: {1}) has role Factory but no linked profile in Factories table.", SessionHelper.UserEmail, userId.Value),
                        Request.UserHostAddress);
                }
                catch { }

                Response.Redirect("~/Account/AccessDenied.aspx?error=profile_not_configured", true);
            }
        }

        private void ResolveFactoryIdentity(int userId)
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string sql = "SELECT FactoryId, CompanyName, City FROM Factories WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add(new SqlParameter("@UserId", SqlDbType.Int) { Value = userId });
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            CurrentFactoryId = Convert.ToInt32(rdr["FactoryId"]);
                            CurrentFactoryName = rdr["CompanyName"] != DBNull.Value ? rdr["CompanyName"].ToString() : "Industrial Plant";
                            CurrentFactoryCity = rdr["City"] != DBNull.Value ? rdr["City"].ToString() : "Regional Hub";
                        }
                        else
                        {
                            CurrentFactoryId = 0;
                            CurrentFactoryName = string.Empty;
                            CurrentFactoryCity = string.Empty;
                        }
                    }
                }
            }
        }
    }
}
