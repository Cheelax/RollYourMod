import DrugInventoryInfo from "./components/DrugInventoryInfo";
import CharacterStats from "./components/CharacterStats";
import { Map } from "./components/Map";
import { PlayerComponent } from "./components/PlayerSprite";
import Button from "./components/Button";

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

  return (
    <div className="flex flex-col h-screen m-4">
      <div className="flex flex-1 min-h-0">
        {/* Map takes the majority of the screen */}
        <div className="flex-grow relative p-2 bg-opacity-50">
          {/*  this is in the coord size not png size */}
          <Map width={10} height={10}>
          </Map>
          
          <PlayerComponent width={10} height={10} />  
        </div>
        {/* Sidebar for character stats */}
        <div className="w-1/4 min-w-min overflow-auto p-2 bg-opacity-50">
          <CharacterStats characterData={characterData} />
        </div>
      </div>
      {/* Bottom bar for actions and inventory */}
      <div className="flex justify-between items-center p-2 fixed inset-x-0 bottom-0 bg-opacity-50">
        {/* Buttons for actions */}
        <div className="flex gap-4">
          <Button onClick={() => console.log("attack")}>Attack</Button>
          <Button onClick={() => console.log("take drugs")}>Take Drugs</Button>
        </div>
        {/* Flex container for inventory information */}
        <div className="flex-1 flex justify-end">
          <DrugInventoryInfo />
        </div>
      </div>
    </div>
  );
}

export default App;
