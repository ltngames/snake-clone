package entities;

import hxd.Math;
import h2d.RenderContext;
import hxd.Direction;
import core.Sprite;

class Body extends Sprite {
  public var direction: Direction;

  public function new(x, y, parent) {
    var tile = Res.img.snake_body.toTile();
    tile.setCenterRatio();
    super(x, y, tile, false, parent);
  }

  public override function sync(ctx: RenderContext) {
    super.sync(ctx);
    switch direction {
      case Up:
        bitmap.rotation = 0;
      case Down:
        bitmap.rotation = 0;
      case Left:
        bitmap.rotation = Math.degToRad(-90);
      case Right:
        bitmap.rotation = Math.degToRad(90);
    }
  }
}
