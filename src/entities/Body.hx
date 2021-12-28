package entities;

import hxd.Direction;
import core.Sprite;

class Body extends Sprite {
  public var direction: Direction;

  public function new(x, y, parent) {
    var tile = Res.img.snake_body.toTile();
    tile.setCenterRatio();
    super(x, y, tile, false, parent);
  }
}
