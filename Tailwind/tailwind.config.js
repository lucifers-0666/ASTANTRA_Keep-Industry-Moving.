/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "../**/*.aspx",
    "../**/*.master",
    "../**/*.Master",
    "../MasterPages/**/*.Master",
    "../MasterPages/**/*.master",
    "../Public/**/*.aspx",
    "../Account/**/*.aspx",
    "../**/*.cs",
    "../Content/**/*.js",
    "../Scripts/**/*.js"
  ],
  theme: {
    extend: {
      maxWidth: {
        '7xl': '80rem',     /* 1280px */
        '8xl': '88rem',     /* 1408px */
      },
      colors: {
        slate: {
          950: '#0F172A',
          900: '#172033',
          800: '#273444',
          700: '#3D4D61',
          600: '#526174',
          500: '#68778D',
          300: '#B0BAC7',
          200: '#D9E1EA',
          100: '#F1F5F9',
          50:  '#F8FAFC',
        },
        brand: {
          primary: '#1677FF',
          secondary: '#3B91FF',
          hover: '#0958D9',
        },
        emergency: {
          50: '#FFF7ED',
          100: '#FFEDD5',
          500: '#F97316',
          600: '#EA580C',
          700: '#C2410C',
        },
        copper: {
          50: '#FFFBEB',
          100: '#FEF3C7',
          400: '#D97706',
          500: '#B87333',
          600: '#965A27',
        }
      },
      fontSize: {
        '5xl': ['3rem', { lineHeight: '1.15' }],
        '6xl': ['3.75rem', { lineHeight: '1.1' }],
        '7xl': ['4.5rem', { lineHeight: '1.05' }],
      }
    },
  },
  plugins: [],
}

