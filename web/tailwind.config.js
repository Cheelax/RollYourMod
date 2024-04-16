/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Chicago FLF", "ui-sans-serif", "system-ui"],
      },
      colors: {
        green: "#00ff00",
        custom_green: "#172217",
      },
      textColor: {
        DEFAULT: "#00ff00",
      },
    },
  },
  plugins: [],
};
