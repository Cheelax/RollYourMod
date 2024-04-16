import React, { useEffect, useState } from "react";
import { VStack, HStack, Text, Grid, Box, Card } from "@chakra-ui/react";
import colors from "../theme/colors";
import { BorderImage } from "./icons/BorderImage";

// Sample data and types
type DrugInfo = {
  id: number;
  quantity: number;
  name: string;
};

const sampleDrugs: DrugInfo[] = [
  { id: 1, quantity: 50, name: "Cocaine" },
  { id: 2, quantity: 75, name: "Weed" },
  { id: 3, quantity: 20, name: "Heroin" },
];

const DrugInventoryInfo = () => {
  const [drugComponents, setDrugComponents] = useState<React.ReactNode[]>([]);

  useEffect(() => {
    const imports = sampleDrugs.map(async (drug) => {
      try {
        console.log("Importing drug icon component for", drug.name);
        const IconComponent = (await import(`./icons/Drugs/${drug.name}`))
          .default;
        console.log("Imported drug icon component for", IconComponent);
        return <IconComponent key={drug.name} boxSize="24px" />;
      } catch (error) {
        console.error(
          `Could not load drug icon component for ${drug.name}`,
          error
        );
        return <Text key={drug.name}>Icon not found</Text>;
      }
    });

    Promise.all(imports).then(setDrugComponents);
  }, []);

  return (
    <VStack w="full">
      <Card
        w="full"
        p="5px"
        pointerEvents="all"
        sx={{
          borderImageSource: `url("data:image/svg+xml,${BorderImage({
            color: colors.neon["700"].toString(),
          })}")`,
        }}
      >
        <HStack
          spacing={4}
          align="center"
          justify="center"
          position="relative"
          p={2}
          border="2px"
          borderColor="neon.900"
          bg="neon.200"
        >
          {drugComponents.map((Component, index) => (
            <React.Fragment key={`drug-${index}`}>
              {Component}
              <Text>Quantity: {sampleDrugs[index].quantity}</Text>
            </React.Fragment>
          ))}
        </HStack>
      </Card>
    </VStack>
  );
};

export default DrugInventoryInfo;
