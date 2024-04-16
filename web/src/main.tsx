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

const theme = extendTheme({
  fonts: {
    body: "Chicago FLF, ui-sans-serif, system-ui",
    heading: "Chicago FLF, ui-sans-serif, system-ui",
  },
  colors,
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
