import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import "./theme/fonts.css";
import { ChakraProvider, extendTheme } from "@chakra-ui/react";

const theme = extendTheme({
  fonts: {
    body: "Chicago FLF, ui-sans-serif, system-ui",
    heading: "Chicago FLF, ui-sans-serif, system-ui",
  },
  colors: {
    green: "#00ff00",
    custom_green: "#172217",
  },
  textColor: {
    DEFAULT: "#00ff00",
  },
  styles: {
    global: {
      "html, body": {
        color: "green", // Use the color key defined in the theme
        backgroundColor: "custom_green", // Use the color key defined in the theme
      },
    },
  },
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ChakraProvider theme={theme}>
      <App />
    </ChakraProvider>
  </React.StrictMode>
);
