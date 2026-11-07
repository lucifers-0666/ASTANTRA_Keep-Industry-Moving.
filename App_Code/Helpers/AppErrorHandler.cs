using System;
using System.Diagnostics;

namespace IndustrialSparePartPortal.App_Code.Helpers
{
    /// <summary>
    /// Centralized application error handling and sanitized messaging helper.
    /// Prevents raw SQL syntax, connection strings, and stack traces from leaking to presentation UI.
    /// </summary>
    public static class AppErrorHandler
    {
        public static string LogAndSanitizeError(Exception ex, string operationContext, out string refId)
        {
            refId = "ERR-" + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpperInvariant();

            try
            {
                Trace.TraceError(
                    "[{0}] Operation: {1} | Exception: {2} | StackTrace: {3}",
                    refId,
                    operationContext ?? "Unknown Context",
                    ex != null ? ex.Message : "Null Exception",
                    ex != null ? ex.StackTrace : "No StackTrace"
                );
            }
            catch
            {
                // Fail-safe: Never throw inside the error logger
            }

            return string.Format(
                "{0}. An unexpected system condition occurred (Reference: {1}). Please contact system operations if this persists.",
                operationContext ?? "Operation failed",
                refId
            );
        }

        public static string FormatSafeErrorMessage(Exception ex, string operationContext)
        {
            string refId;
            return LogAndSanitizeError(ex, operationContext, out refId);
        }
    }
}
