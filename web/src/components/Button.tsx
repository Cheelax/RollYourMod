import {
  Button as ChakraButton,
  ButtonProps,
  StyleProps,
  Text,
} from "@chakra-ui/react";
import { ReactNode } from "react";

// Can't seem to set first-letter css correctly on button in chakra theme
// so we do it here on text...
const Button = ({
  children,
  ...props
}: { children: ReactNode } & StyleProps & ButtonProps) => (
  <ChakraButton
    {...props}
    onClick={(e) => {
      props.onClick && props.onClick(e);
    }}
  >
    <Text
      as="div"
      w="full"
      textAlign="center"
      // css={{
      //   "&:first-letter": {
      //     textDecoration: "underline",
      //   },
      // }}
    >
      {children}
    </Text>
  </ChakraButton>
);

export default Button;
