package entities;

import hxd.Direction;
import h2d.RenderContext;
import hxd.Key;
import hxd.Math;
import core.Sprite;

using Array;

class Player extends Sprite {
  public var SPEED: Int = 2;
  public var direction: Direction = Up;
  public var allowUpdate: Bool = true;

  public function new(x, y, ?parent) {
    var graphic = Res.img.snake_head.toTile();
    super(x, y, graphic, true, parent);
    tile.setCenterRatio();
  }

  public override function sync(ctx: RenderContext) {
    super.sync(ctx);
    if (allowUpdate) {
      syncDirection();
      syncMovement();
    }
  }

  private function syncDirection() {
    if (Key.isDown(Key.W) && direction != Down) {
      direction = Up;
      rotation = 0;
    }
    if (Key.isDown(Key.S) && direction != Up) {
      direction = Down;
      rotation = Math.degToRad(180);
    }
    if (Key.isDown(Key.A) && direction != Right) {
      direction = Left;
      rotation = Math.degToRad(-90);
    }
    if (Key.isDown(Key.D) && direction != Left) {
      direction = Right;
      rotation = Math.degToRad(90);
    }
  }

  private function syncMovement() {
    var tmod = hxd.Timer.tmod;
    x = x;
    y = y;
    switch direction {
      case Up:
        y -= SPEED * tmod;
      case Down:
        y += SPEED * tmod;
      case Left:
        x -= SPEED * tmod;
      case Right:
        x += SPEED * tmod;
    }
  }
}
