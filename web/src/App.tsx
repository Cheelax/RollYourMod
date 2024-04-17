import "./index.css";
import "./theme/fonts.css";
import DrugInventoryInfo from "./components/DrugInventoryInfo";
import CharacterStats from "./components/CharacterStats";
import { Map } from "./components/Map";

function App() {
  const weapon = {
    name: "Longsword",
    range: 5,
  };

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
      <div className="fixed bottom-0 right-0 w-1/4 h-1/10 overflow-auto">
        <DrugInventoryInfo />
      </div>
    </>
  );
}

export default App;
