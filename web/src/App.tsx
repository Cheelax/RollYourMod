import { useState } from "react";
import { Button, useDisclosure } from "@chakra-ui/react";
import DrugInventoryInfo from "./components/DrugInventoryInfo";
import CharacterStats from "./components/CharacterStats";
import { Map } from "./components/Map";
import { PlayerComponent } from "./components/PlayerSprite";
import { Acid, Cocaine, Heroin, Speed, Weed } from "./components/icons/Drugs";
import { DrugModal } from "./components/DrugModal";
import { hash } from "starknet";

function App() {
  const weapon = {
    name: "Longsword",
    range: 5,
  };

  const characterData = {
    name: "Aragorn",
    str: 7,
    bonusStr: 2,
    speed: 5,
    bonusSpeed: 1,
    defense: 8,
    bonusDefense: 3,
    weapon: weapon,
    drugCount: 10,
  };

  const { isOpen, onOpen, onClose } = useDisclosure();
  const [drugs, setDrugs] = useState([
    { id: 1, name: "Acid", icon: Acid, quantity: 0 },
    { id: 2, name: "Cocaine", icon: Cocaine, quantity: 0 },
    { id: 3, name: "Heroin", icon: Heroin, quantity: 0 },
    { id: 4, name: "Speed", icon: Speed, quantity: 0 },
    { id: 5, name: "Weed", icon: Weed, quantity: 0 },
  ]);

  const handleQuantityChange = (
    valueAsString: string,
    valueAsNumber: number,
    id: number
  ) => {
    setDrugs((currentDrugs) =>
      currentDrugs.map((drug) =>
        drug.id === id ? { ...drug, quantity: valueAsNumber } : drug
      )
    );
  };

  const _weapon = 1;
  const clothes = 1;
  const shoes = 1;
  const bag = 1;

  const shrooms = 1;
  const cocaine = 1;
  const ketamine = 1;
  const speed = 1;

  const elements = [
    BigInt(_weapon),
    BigInt(clothes),
    BigInt(shoes),
    BigInt(bag),
    BigInt(shrooms),
    BigInt(cocaine),
    BigInt(ketamine),
    BigInt(speed),
  ];

  const hashed = hash.computeHashOnElements(elements);

  return (
    <div className="flex flex-col h-screen m-4">
      <div className="flex flex-1 min-h-0">
        <div className="flex-grow relative p-2 bg-opacity-50">
          {/*  this is in the coord size not png size */}
          <Map width={10} height={10}></Map>

          <PlayerComponent width={10} height={10} />
        </div>
        <div className="w-1/4 min-w-min overflow-auto p-2 bg-opacity-50">
          <CharacterStats characterData={characterData} />
        </div>
      </div>
      <div className="p-2 fixed inset-x-0 bottom-0 bg-opacity-50">
        <div className="flex justify-between items-center">
          <Button onClick={() => console.log("attack")}>Attack</Button>
          <Button colorScheme="blue" onClick={onOpen}>
            Take Drugs
          </Button>
          <DrugInventoryInfo />
        </div>
      </div>

      {/* Modal */}
      <DrugModal
        isOpen={isOpen}
        onClose={onClose}
        drugs={drugs}
        handleQuantityChange={handleQuantityChange}
      />
    </div>
  );
}

export default App;
