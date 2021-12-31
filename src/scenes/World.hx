package scenes;

import hxd.Key;
import hxd.res.DefaultFont;
import h2d.Console;
import hxd.Direction;
import h2d.col.Point;
import entities.Body;
import core.Scene;
import entities.Player;

class World extends Scene {
  public var console: Console;
  public var player: Player;
  public var snakeTick: haxe.Timer;

  var bodyParts: Array<Body> = [];

  public function setupConsole() {
    var consoleFont = DefaultFont.get().clone();
    console = new Console(consoleFont, this);
    console.addCommand("addSegment", "Add another segment to the snake", [], () -> {
      addBody();
    });
  }

  public override function init() {
    player = new Player(width / 2, height / 2, this);
    setupConsole();
    snakeTick = new haxe.Timer(150);
    snakeTick.run = moveSnake;
  }

  public function addBody() {
    var prev = bodyParts[bodyParts.length - 1];
    var body: Body;
    var pos: Point;
    if (prev != null) {
      pos = getNextPosition(prev.x, prev.y, prev.direction);
      body = new Body(pos.x, pos.y, this);
      body.direction = prev.direction;
    } else {
      pos = getNextPosition(player.x, player.y, player.direction);
      body = new Body(pos.x, pos.y, this);
      body.direction = player.direction;
    }

    bodyParts.push(body);
  }

  public function getNextPosition(x: Float, y: Float, direction: Direction): Point {
    var position: Point = new Point(0, 0);

    switch direction {
      case Up:
        position = new Point(x, y + 8);
      case Down:
        position = new Point(x, y - 8);
      case Left:
        position = new Point(x + 8, y);
      case Right:
        position = new Point(x - 8, y);
      case _:
        position = new Point(x, y + 8);
    }

    return position;
  }

  public override function onResize() {}

  public override function update(dt: Float) {
    updateConsole();
  }

  private function moveSnake() {
    var tail = bodyParts[bodyParts.length - 1];
    if (tail != null && player.allowUpdate) {
      var pos = getNextPosition(player.x, player.y, player.direction);
      tail.setPosition(pos.x, pos.y);
      bodyParts.pop();
      bodyParts.unshift(tail);
    }
  }

  private function updateConsole() {
    if (Key.isPressed(Key.QWERTY_TILDE)) {
      if (console.isActive()) {
        player.allowUpdate = true;
        console.hide();
      } else {
        player.allowUpdate = false;
        console.runCommand("cls");
        console.log("Console ready");
        console.show();
      }
    }
  }

  public override function dispose() {}
}
