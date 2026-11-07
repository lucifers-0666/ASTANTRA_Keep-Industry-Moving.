using System;
using System.Security.Cryptography;
using System.Text;

namespace IndustrialSparePartPortal.App_Code.Helpers
{
    /// <summary>
    /// Enterprise cryptographic helper implementing PBKDF2 (HMAC-SHA256) password hashing
    /// with constant-time verification and transparent backwards compatibility for legacy SHA-256 hashes.
    /// </summary>
    public static class PasswordHasher
    {
        private const int SaltByteSize = 16;
        private const int HashByteSize = 32;
        private const int Pbkdf2Iterations = 10000;
        private const string Pbkdf2Prefix = "PBKDF2$";

        /// <summary>
        /// Generates a cryptographically strong random salt.
        /// </summary>
        public static string GenerateSalt(int size = SaltByteSize)
        {
            byte[] saltBytes = new byte[size];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        /// <summary>
        /// Computes a PBKDF2 hash of the password using HMAC-SHA256 and the provided salt.
        /// Format returned: PBKDF2$10000$<Base64Hash>
        /// </summary>
        public static string HashPassword(string password, string salt)
        {
            if (string.IsNullOrEmpty(password)) throw new ArgumentNullException("password");
            if (string.IsNullOrEmpty(salt)) throw new ArgumentNullException("salt");

            byte[] saltBytes;
            try
            {
                saltBytes = Convert.FromBase64String(salt);
            }
            catch
            {
                saltBytes = Encoding.UTF8.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Pbkdf2Iterations, HashAlgorithmName.SHA256))
            {
                byte[] hashBytes = pbkdf2.GetBytes(HashByteSize);
                return string.Format("{0}{1}${2}", Pbkdf2Prefix, Pbkdf2Iterations, Convert.ToBase64String(hashBytes));
            }
        }

        /// <summary>
        /// Verifies an entered password against the stored hash and salt.
        /// Supports both new PBKDF2 hashes and legacy SHA-256 hashes for seamless user migration.
        /// </summary>
        public static bool VerifyPassword(string enteredPassword, string storedHash, string storedSalt)
        {
            if (string.IsNullOrEmpty(enteredPassword) || string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(storedSalt))
            {
                return false;
            }

            // Case 1: Stored hash is modern PBKDF2
            if (storedHash.StartsWith(Pbkdf2Prefix, StringComparison.OrdinalIgnoreCase))
            {
                string[] parts = storedHash.Split('$');
                if (parts.Length == 3)
                {
                    int iterations;
                    if (!int.TryParse(parts[1], out iterations))
                    {
                        iterations = Pbkdf2Iterations;
                    }

                    byte[] expectedHashBytes = Convert.FromBase64String(parts[2]);

                    byte[] saltBytes;
                    try
                    {
                        saltBytes = Convert.FromBase64String(storedSalt);
                    }
                    catch
                    {
                        saltBytes = Encoding.UTF8.GetBytes(storedSalt);
                    }

                    using (var pbkdf2 = new Rfc2898DeriveBytes(enteredPassword, saltBytes, iterations, HashAlgorithmName.SHA256))
                    {
                        byte[] actualHashBytes = pbkdf2.GetBytes(expectedHashBytes.Length);
                        return SlowEquals(actualHashBytes, expectedHashBytes);
                    }
                }
            }

            // Case 2: Legacy SHA-256 fallback for existing accounts
            using (var sha256 = SHA256.Create())
            {
                byte[] combinedBytes = Encoding.UTF8.GetBytes(enteredPassword + storedSalt);
                byte[] hashBytes = sha256.ComputeHash(combinedBytes);
                string legacyHash = Convert.ToBase64String(hashBytes);

                if (string.Equals(legacyHash, storedHash, StringComparison.Ordinal))
                {
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// Constant-time byte array comparison to protect against timing attacks.
        /// </summary>
        private static bool SlowEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
            {
                return false;
            }

            int diff = 0;
            for (int i = 0; i < a.Length; i++)
            {
                diff |= a[i] ^ b[i];
            }
            return diff == 0;
        }
    }
}
