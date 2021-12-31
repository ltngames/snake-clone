package entities;

import hxd.Direction;
import h2d.RenderContext;
import hxd.Key;
import hxd.Math;
import core.Sprite;

using Array;

class Player extends Sprite {
  public var direction: Direction = Up;

  public function new(x, y, ?parent) {
    var graphic = Res.img.snake_head.toTile();
    super(x, y, graphic, true, parent);
    tile.setCenterRatio();
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
