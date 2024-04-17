import "./Map.css";

export const Map = ({ width, height }: { width: number; height: number }) => {
  // Handler for clicking on a tile
  const handleTileClick = (x: number, y: number) => {
    alert(`Tile clicked: X=${x}, Y=${y}`);
    // Perform other actions based on click if needed
  };

  // Generate the grid of tiles based on width and height
  const tiles = [];
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      tiles.push(
        <div
          key={`${x},${y}`}
          className="tile"
          onClick={() => handleTileClick(x, y)}
        />
      );
    }
  }

  return (
    <div className="flex justify-center items-start">
      <div
        className="map"
        style={{ gridTemplateColumns: `repeat(${width}, 1fr)` }}
      >
        {tiles}
      </div>
    </div>
  );
};
