import { useEffect, useState } from "react";
import "./Map.css";

export const PlayerComponent = ({ width, height }: { width: number; height: number }) => {
  const [playerPosition, setPlayerPosition] = useState<{ x: number; y: number }>({ x: 0, y: 0 });
  const sizeOfTile = 105; // The size of the sprites
  
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const { key } = event;
      switch (key) {
        case "w":
          setPlayerPosition(prev => ({ ...prev, y: Math.max(prev.y - 1, 0) }));
          break;
        case "s":
          setPlayerPosition(prev => ({ ...prev, y: Math.min(prev.y + 1, 9) }));
          break;
        case "a":
          setPlayerPosition(prev => ({ ...prev, x: Math.max(prev.x - 1, 0) }));
          break;
        case "d":
          setPlayerPosition(prev => ({ ...prev, x: Math.min(prev.x + 1, width - 1) }));
          break;
        default:
          return;
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [playerPosition]);

  return (
    <div className="flex justify-center items-start">
      <div className="map"  style={{ position: "relative" }}>
        <div
          style={{
            left:( playerPosition.x * sizeOfTile  ) - (width * sizeOfTile)/2,
            top: ( playerPosition.y * sizeOfTile  ) - sizeOfTile * height,
            position: "absolute",
            width: sizeOfTile,
            height: sizeOfTile  ,
            backgroundColor: "green",
          }}
        ></div>
      </div>
    </div>
  );
};
