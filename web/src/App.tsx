import "./index.css";
import "./theme/fonts.css";
import DrugInventoryInfo from "./components/DrugInventoryInfo";
import CharacterStats from "./components/CharacterStats";
import { Map } from "./components/Map";
import Button from "./components/Button";
import { useDojo } from "./dojo/useDojo";
import { useEffect } from "react";

function App() {
  const {
    setup: {
      client: { game_actions },
    },
    account: { account },
  } = useDojo();
  const weapon = {
    name: "Longsword",
    range: 5,
  };

  useEffect(() => {
    const initializeGame = async () => {
      try {
        await game_actions.create(
          account,
          "0x066663598D1120F97aaD74bCCC0c162f89F12b8A3fA444F6cAAcb6BccC500600"
        );
      } catch (error) {
        console.error("Error initializing game:", error);
      }
    };

    initializeGame();
  }, [game_actions, account]);
  // Example character data
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

  return (
    <>
      <div>
        <Map width={10} height={10}></Map>
      </div>
      <div className="fixed right-0 top-0 h-full w-1/10 overflow-auto">
        <CharacterStats characterData={characterData} />
      </div>
      <div className="fixed bottom-0 w-full flex justify-around items-center px-4 py-2">
        <Button onClick={() => console.log("attack")}>Attack</Button>
        <Button onClick={() => console.log("take drugs")}>Take Drugs</Button>
        <div className="flex-1 w-1/4 h-1/10 overflow-auto">
          <DrugInventoryInfo />
        </div>
      </div>
    </>
  );
}

export default App;
