package scenes;

import hxd.Direction;
import h2d.col.Point;
import haxe.ds.Vector;
import entities.Body;
import core.Scene;
import entities.Player;

class World extends Scene {
  public var player: Player;

  var bodyParts: Array<Body> = [];

  public override function init() {
    player = new Player(width / 2, height / 2, this);
  }

  public function addBody() {
    var prev = bodyParts[bodyParts.length - 1];
    var body: Body;
    var pos: Point;

    if (prev != null) {
      pos = getNextBodyPartPosition(prev.x, prev.y, prev.direction);
      body = new Body(pos.x, pos.y, this);
      body.direction = prev.direction;
    } else {
      pos = getNextBodyPartPosition(player.x, player.y, player.direction);
      body = new Body(pos.x, pos.y, this);
      body.direction = player.direction;
    }
    bodyParts.push(body);
  }

  public function getNextBodyPartPosition(x: Float, y: Float, direction: Direction): Point {
    var position: Point = new Point(0, 0);

    switch direction {
      case Up:
        position = new Point(x, y + 16);
      case Down:
        position = new Point(x, y - 16);
      case Left:
        position = new Point(x + 16, y);
      case Right:
        position = new Point(x - 16, y);
    }

    return position;
  }

  public override function onResize() {}

  public override function update(dt: Float) {}

  public override function dispose() {}
}
