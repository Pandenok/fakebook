module.exports = {
  purge: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        lgreen: '#42b72a',
        greenhover: '#36a420',
        signupgreen: '#00a400',
        lblue: '#1877f2',
        bluehover: '#166fe5',
        lgray: '#f0f2f5',
        secondarygray: '#606770',
        newred: '#f02849',
      },
      fontSize: {
        'xll': ['1.75rem', { lineHeight: '2rem' }],
      },
      spacing: {
        125: '31.25rem',
      }
    },
  },
  variants: {
    extend: {
      borderRadius: ['responsive', 'hover'],
    },
  },
  plugins: [],
}
