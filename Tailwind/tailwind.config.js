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
        '6xl': '72rem',     /* 1152px */
        '7xl': '76.25rem',  /* 1220px */
        '8xl': '88rem',     /* 1408px */
      },
      colors: {
        canvas: '#F1F3F5',
        surface: '#FFFFFF',
        brand: {
          primary: '#1769E0',
          hover: '#1358BE',
          dark: '#0E47A1',
          light: '#EBF3FC',
        },
        emergency: {
          50: '#FEF3EB',
          100: '#FCD5B5',
          500: '#E87519',
          600: '#D06410',
          700: '#B5520A',
        },
        industrial: {
          navy: '#101C2C',
          dark: '#17263A',
          border: '#D9DEE5',
          subtle: '#E9ECEF',
          text: '#111827',
          secondary: '#5F6B7A',
          muted: '#7E8B9B',
        }
      },
      borderRadius: {
        'sm': '4px',
        'DEFAULT': '6px',
        'md': '6px',
        'lg': '8px',
        'xl': '10px',
      }
    },
  },
  plugins: [],
}

