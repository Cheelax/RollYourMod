import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./index.css";
import "./theme/fonts.css";
import Button from "./components/Button";
import DrugInventoryInfo from "./components/DrugInventoryInfo";
import CharacterStats from "./components/CharacterStats";

function App() {
  const [count, setCount] = useState(0);

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
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <Button> Click me</Button>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
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
