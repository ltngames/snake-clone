package scenes;

import h2d.Graphics;
import h2d.Object;
import entities.Food;
import hxd.Math;
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
  public var foods: Array<Food> = [];
  public var snakeTick: haxe.Timer;
  public var foodTick: haxe.Timer;
  public var gridSize = 16;
  public var snakeSpeed = 1;

  var bodyParts: Array<Body> = [];

  public function setupConsole() {
    var consoleFont = DefaultFont.get().clone();
    console = new Console(consoleFont, this);
    console.addCommand("addSegment", "Add another segment to the snake", [], () -> {
      addBody();
    });
  }

  public override function init() {
    drawBackground();
    player = new Player(width / 2, height / 2, this);
    setupConsole();
    foodTick = new haxe.Timer(66);
    snakeTick = new haxe.Timer(66);
    snakeTick.run = moveSnake;
    foodTick.run = addFood;
  }

  public function drawBackground() {
    var graphics = new h2d.Graphics(this);
    var cols = Math.floor(width / gridSize);
    var rows = Math.floor(height / gridSize);

    for (x in 0...cols) {
      for (y in 0...rows) {
        var isEven = y % 2 == 0;
        if (x % 2 == 0) {
          if (isEven) {
            graphics.beginFill(0x306230);
          } else {
            graphics.beginFill(0x0f380f);
          }
        } else {
          if (isEven) {
            graphics.beginFill(0x0f380f);
          } else {
            graphics.beginFill(0x306230);
          }
        }
        graphics.drawRect(x * gridSize, y * gridSize, width, height);
      }
    }
    graphics.endFill();
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

  public function randomInt(min: Float, max: Float): Int {
    return Math.floor(Math.random() * (1 + max - min) + min);
  }

  public function addFood() {
    if (foods.length >= 1) {
      return;
    }
    var food = new Food(0, 0, this);
    var gridLocation = new Point(randomInt(0, width / 16), randomInt(0, height / 16));
    food.setPosition(gridLocation.x * 16 - 8, gridLocation.y * 16 - 8);
    foods.push(food);
  }

  public function collides(objectA: Object, objectB: Object) {
    var rectA = objectA.getBounds();
    var rectB = objectB.getBounds();
    return rectA.intersects(rectB);
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
    updateInput();
    if (foods[0] != null) {
      if (collides(player, foods[0])) {
        addBody();
        removeChild(foods[0]);
        foods.shift();
      }
    }
  }

  private function moveSnake() {
    if (console.isActive() == true) {
      return;
    }
    var tail = bodyParts[bodyParts.length - 1];
    if (tail != null) {
      var pos = getNextPosition(player.x, player.y, player.direction);
      tail.setPosition(Math.floor(player.x), Math.floor(player.y));
      tail.direction = player.direction;
      bodyParts.pop();
      bodyParts.unshift(tail);
    }

    var moveSpeed = snakeSpeed * gridSize;
    switch player.direction {
      case Up:
        player.y -= moveSpeed;
      case Down:
        player.y += moveSpeed;
      case Left:
        player.x -= moveSpeed;
      case Right:
        player.x += moveSpeed;
    }
  }

  private function updateInput() {
    if (Key.isDown(Key.W) && player.direction != Down) {
      player.direction = Up;
    }
    if (Key.isDown(Key.S) && player.direction != Up) {
      player.direction = Down;
    }
    if (Key.isDown(Key.A) && player.direction != Right) {
      player.direction = Left;
    }
    if (Key.isDown(Key.D) && player.direction != Left) {
      player.direction = Right;
    }
  }

  private function updateConsole() {
    if (Key.isPressed(Key.QWERTY_TILDE)) {
      if (console.isActive()) {
        console.hide();
      } else {
        console.runCommand("cls");
        console.log("Console ready");
        console.show();
      }
    }
  }

  public override function dispose() {}
}
