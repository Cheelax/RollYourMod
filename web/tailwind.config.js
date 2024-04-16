/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Chicago FLF", "ui-sans-serif", "system-ui"],
      },
      colors: {
        green: "#00ff00", // Remplacez cette valeur par la teinte exacte de vert que vous voulez.
      },
      textColor: {
        DEFAULT: "#00ff00", // Utilisez le même vert ici pour la couleur de texte par défaut.
      },
    },
  },
  plugins: [],
};
