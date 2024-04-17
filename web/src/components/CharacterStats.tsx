import React from "react";
import { Box, VStack, Text } from "@chakra-ui/react";

type Weapon = {
  name: string;
  range: number;
};

type CharacterData = {
  name: string;
  str: number;
  bonusStr: number;
  speed: number;
  bonusSpeed: number;
  defense: number;
  bonusDefense: number;
  weapon: Weapon;
  //   drugCount: number;
};

const CharacterStats = ({
  characterData,
}: {
  characterData: CharacterData;
}) => {
  return (
    <VStack
      align="stretch"
      p={4}
      borderColor="neon.900"
      bg="neon.900"
      //   color="white"
      border="2px solid"
      spacing={4}
      borderRadius="lg"
    >
      <Box bg="neon.500" p={2} borderRadius="md" alignSelf="center">
        <Text fontWeight="bold" textAlign="center">
          {characterData.name}
        </Text>
      </Box>
      <VStack align="stretch" spacing={2}>
        <Text>
          Str: {characterData.str} +{characterData.bonusStr}
        </Text>
        <Text>
          Speed: {characterData.speed} +{characterData.bonusSpeed}
        </Text>
        <Text>
          Defense: {characterData.defense} +{characterData.bonusDefense}
        </Text>
        <VStack
          bg="neon.900"
          p={2}
          borderRadius="md"
          border="1px solid"
          borderColor="white"
        >
          <Text fontWeight="bold">Weapon:</Text>
          <Text>Name: {characterData.weapon.name}</Text>
          <Text>Range: {characterData.weapon.range}</Text>
        </VStack>
        {/* <Text>You took: {characterData.drugCount} drugs</Text> */}
      </VStack>
    </VStack>
  );
};

export default CharacterStats;
