import { generatePixelBorderPath } from "../../utils/ui";
import { ComponentStyleConfig } from "@chakra-ui/react";

import colors from "../colors";

export const Button: ComponentStyleConfig = {
  defaultProps: {
    variant: "primary",
  },
  baseStyle: {
    fontWeight: "400",
    textTransform: "uppercase",
    position: "relative",
    borderStyle: "solid",
    borderWidth: "2px",
    borderImageSlice: "4",
    borderImageWidth: "4px",
    px: "40px",
    gap: "10px",
    bgColor: "neon.900",
    transition: "none",
    _active: {
      top: "2px",
      left: "2px",
    },
    _disabled: {
      pointerEvents: "none",
    },
  },
  variants: {
    primary: {
      color: "neon.200",

      _hover: {
        color: "neon.300",
      },
      _active: {},
    },
    selectable: {
      color: "neon.200",

      _hover: {
        color: "neon.300",
      },
      _active: {
        color: colors.yellow["400"].toString(),
      },
    },
    pixelated: {
      border: 0,
      bg: "neon.700",
      lineHeight: "1em",
      clipPath: `polygon(${generatePixelBorderPath()})`,
      _hover: {
        bg: "neon.600",
      },
    },
    default: {},
  },
};
