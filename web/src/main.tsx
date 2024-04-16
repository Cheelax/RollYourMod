import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import "./theme/fonts.css";
import { ChakraProvider, extendTheme } from "@chakra-ui/react";
import { textStyles, layerStyles } from "./theme/styles.ts";
import { styles } from "./theme/styles.ts";
import colors from "./theme/colors";
import * as Components from "./theme/components";
import breakpoints from "./theme/breakpoints";

// 2. Call `extendTheme` and pass your custom values
const theme = extendTheme({
  fonts: {
    body: "Chicago FLF, ui-sans-serif, system-ui",
    heading: "Chicago FLF, ui-sans-serif, system-ui",
  },
  colors,
  // styles: {
  //   global: {
  //     "html, body": {
  //       color: "green", // Use the color key defined in the theme
  //       backgroundColor: "neon.900", // Use the color key defined in the theme
  //     },
  //   },
  // },
  styles,
  textStyles,
  layerStyles,
  breakpoints,
  components: {
    ...Components,
  },
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ChakraProvider theme={theme}>
      <App />
    </ChakraProvider>
  </React.StrictMode>
);
