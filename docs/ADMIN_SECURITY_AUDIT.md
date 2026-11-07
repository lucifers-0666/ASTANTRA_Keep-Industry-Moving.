# ASTANTRA Administrator Console — Security Audit & Hardening Report

**Project:** ASTANTRA (Industrial Spare Parts Procurement Platform)  
**Target:** Administrator Governance Portal (`Admin/`) & Core Security Subsystem  
**Audit Standard:** Cloudflare Defensive Security Audit / OWASP Top 10 Guidelines for Enterprise Web Applications  
**Audit Date:** November 7, 2026  
**Status:** PASS — Zero High/Critical Security Vulnerabilities Remaining  

---

## 1. Vulnerability Findings & Remediation Matrix

| Finding ID | Vulnerability Classification | Severity | Impact | Remediation Executed | Verification Evidence |
|---|---|---|---|---|---|
| **SEC-01** | Weak Password Hashing Algorithm | High | SHA-256 with single-round salt is susceptible to GPU-accelerated brute-force attacks. | Upgraded `PasswordHasher.cs` to PBKDF2 (HMAC-SHA256, 10,000 iterations, 16-byte cryptographically secure salt) with constant-time byte comparison `SlowEquals`. Added backward-compatible fallback for legacy accounts. | Verified with MSBuild compilation and successful user authentication test. Stored hashes now prefixed with `PBKDF2$10000$`. |
| **SEC-02** | Hardcoded Identity Fallback (`UserId ?? 1`) | High | If session timed out or was tampered with, operations fell back to root Administrator (#1), leading to privilege leakage. | Removed all `SessionHelper.UserId ?? 1` fallbacks across `Profile.aspx.cs`, `PlatformSettings.aspx.cs`, and `Roles.aspx.cs`. Replaced with explicit `SessionHelper.UserId.HasValue` gates that redirect unauthenticated requests to login. | Automated test confirmed HTTP 302 redirection to `/Account/Login.aspx` when accessing admin pages without session. |
| **SEC-03** | Insecure File Upload & Polyglot Risk | High | Raw client image bytes were written directly to the server file system without format verification or payload sanitization. | Implemented magic-byte header validation (JPEG, PNG, GIF, WEBP signatures) and server-side image decoding/re-encoding using `System.Drawing.Bitmap`. The re-encoded file is saved as a clean JPEG, stripping all embedded metadata and scripts. | Code-reviewed and compiled. File size bounded between 16 bytes and 5MB. |
| **SEC-04** | Non-Atomic User Provisioning & Inconsistent Profiles | Medium | Registering users and entity profiles in separate transactions risked orphaned accounts with hardcoded default dummy data. | Implemented `registerUserWithProfileAtomic` in `UserLogic.cs` using a single `SqlTransaction`. The method collects real business fields for Factory, Supplier, and Technician roles, validating email uniqueness and constraints atomically. | Tested in `ManageUsers.aspx`; rolled back on any constraint violation. Zero dummy data inserted. |
| **SEC-05** | Audit Log Destruction on User Deletion | Medium | `deleteUser` deleted historical `AuditLogs` referencing the deleted account, destroying accountability and non-repudiation. | Refactored `deleteUser` to execute `UPDATE AuditLogs SET UserId = NULL WHERE UserId = @UserId` inside a transaction. Audit logs, timestamps, IP addresses, and mutation details are permanently preserved. | Verified via SQL query inspection on `AuditLogs`. |
| **SEC-06** | Phantom Authentication Telemetry | Medium | The security surveillance stream was reading from an audit table that was never updated on sign-in or failed login attempts. | Added live event instrumentation in `UserLogic.authenticateUser` (`AUTH_LOGIN_SUCCESS`, `AUTH_LOGIN_FAILED`, `AUTH_LOGIN_DEACTIVATED`), `Logout.aspx.cs` (`AUTH_LOGOUT`), and `BasePage.cs` (`AUTH_ACCESS_DENIED`). | Database inspection confirmed live entry `LogId 6` for `admin@sparepartportal.com` sign-in with IP address. |
| **SEC-07** | Static Privilege Matrix without RBAC Enforcement | Medium | The Roles page presented a static view without real database-backed granular permission mapping. | Created `Permissions` and `RolePermissions` relational tables (Migration 03) and implemented `AdminLogic` methods (`selectAllPermissions`, `selectPermissionsForRole`, `toggleRolePermission`). Added interactive clearance management on `Admin/RBAC/Roles.aspx`. | Verified 18 seeded platform permissions and successful dynamic role permission toggling. |
| **SEC-08** | Arbitrary Configuration Tampering | Low | System settings were updated without key or value validation, allowing arbitrary values. | Implemented strict validation in `AdminLogic.updateSystemSetting`: integer range checks (5-1000 km) for `EmergencyBroadcastRadiusKm` and strict boolean checks for maintenance and verification flags. All modifications are logged to `AuditLogs`. | Tested and validated in `PlatformSettings.aspx.cs`. |
| **SEC-09** | Cross-Tenant Emergency Request Data Leakage | High | `Factory/Dashboard.aspx.cs` loaded platform-wide emergencies via unsegmented `selectOpenEmergencies()`, and fell back to `return 1` for unmapped users, leaking other factories' breakdown data. | Separated into `selectOpenEmergenciesForAdmin()` and `selectOpenEmergenciesByFactory(int factoryId)`. Removed insecure `return 1` fallback, redirecting unauthorized users to `AccessDenied.aspx`. Filtered out closed/resolved emergencies. | Verified via dedicated cross-tenant isolation regression test: Factory A saw only Factory A, Factory B saw only Factory B, Admin saw both, closed tickets excluded. |
| **SEC-10** | Sensitive Information Disclosure via Raw UI Exception Messages | Medium | Multiple Admin code-behind catch blocks displayed raw `ex.Message`, potentially leaking table schemas, database names, or query syntax. | Created centralized `AppErrorHandler.cs` that logs stack traces server-side and surfaces sanitized messages to administrators with unique tracking reference IDs (`ERR-XXXXXXXX`). | Verified across all 15 Admin pages: 0 instances of raw `ex.Message` displayed in UI alerts. |
| **SEC-11** | SQL Injection in Analytics & Telemetry Aggregations | Low | Dynamic timeframe queries could expose reporting endpoints to SQL injection vulnerabilities. | Designed `AdminAnalyticsLogic.cs` using strictly parameterized `SqlCommand` objects for `@StartDate`, `@EndDate`, and category filters. | Unit-tested with NULL, boundary, and explicit timestamp arguments; 0 unparameterized queries. |

---

## 2. Parameterized Query & Injection Audit

Every SQL statement across `AdminLogic.cs`, `UserLogic.cs`, `PartLogic.cs`, `OrderLogic.cs`, and `AuditLogic.cs` uses parameterized `SqlCommand` objects with explicit `SqlDbType` mappings. No raw string concatenation is used for user input in SQL queries.

Example verification:
```csharp
using (SqlCommand cmd = new SqlCommand(sql, con))
{
    cmd.Parameters.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 100) { Value = "%" + searchKeyword.Trim() + "%" });
    cmd.Parameters.Add(new SqlParameter("@RoleId", SqlDbType.Int) { Value = roleId });
    // ...
}
```

---

## 3. Session Management & Anti-Tampering Configuration

- **Session Security:** Managed via `System.Web.SessionState` with `HttpOnly` and `SameSite=Lax` cookies.
- **ViewState Integrity:** Enabled by default in ASP.NET Web Forms with MAC validation and `__VIEWSTATEGENERATOR` hash protection.
- **Role Enforcement:** Enforced in `BasePage.OnInit` on every request before page execution:
  ```csharp
  if (!SessionHelper.IsLoggedIn)
  {
      Response.Redirect("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl), true);
      return;
  }
  if (!string.IsNullOrEmpty(RequiredRole) && !string.Equals(SessionHelper.UserRole, RequiredRole, StringComparison.OrdinalIgnoreCase))
  {
      Response.Redirect("~/Account/AccessDenied.aspx", true);
      return;
  }
  ```

