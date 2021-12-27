package entities;

import h2d.RenderContext;
import hxd.Key;
import hxd.Math;
import core.Sprite;

enum Direction {
  UP;
  DOWN;
  LEFT;
  RIGHT;
  NONE;
}

class Player extends Sprite {
  public var SPEED: Int = 2;
  public var direction: Direction;

  public function new(x, y, ?parent) {
    var graphic = Res.img.snake_head.toTile();
    super(x, y, graphic, true, parent);
    tile.setCenterRatio();
    direction = NONE;
  }

  public override function sync(ctx: RenderContext) {
    super.sync(ctx);
    syncDirection();
    syncMovement();
  }

  private function syncDirection() {
    if (Key.isDown(Key.W) && direction != DOWN) {
      direction = UP;
      rotation = 0;
    }
    if (Key.isDown(Key.S) && direction != UP) {
      direction = DOWN;
      rotation = Math.degToRad(180);
    }
    if (Key.isDown(Key.A) && direction != RIGHT) {
      direction = LEFT;
      rotation = Math.degToRad(-90);
    }
    if (Key.isDown(Key.D) && direction != LEFT) {
      direction = RIGHT;
      rotation = Math.degToRad(90);
    }
  }

  private function syncMovement() {
    var tmod = hxd.Timer.tmod;
    switch direction {
      case UP:
        y -= SPEED * tmod;
      case DOWN:
        y += SPEED * tmod;
      case LEFT:
        x -= SPEED * tmod;
      case RIGHT:
        x += SPEED * tmod;
      case NONE:
        x = x;
        y = y;
    }
  }
}
