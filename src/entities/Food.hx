package entities;

import h2d.Tile;
import core.Sprite;

class Food extends Sprite {
  public function new(x, y, parent) {
    var tile: Tile = Res.img.snake_food.toTile();
    super(x, y, tile, false, parent);
  }
}
