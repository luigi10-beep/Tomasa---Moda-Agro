import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'sage-light': '#E8F0DC',
        'moss-dark': '#4A6741',
        'almost-black': '#2C2C2C',
        'sage-ultra-light': '#F7F9F3',
        'moss-medium': '#5C7A52',
      },
      fontFamily: {
        display: ['Cormorant Garamond', 'serif'],
        cursive: ['Dancing Script', 'cursive'],
        sans: ['Jost', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
export default config
