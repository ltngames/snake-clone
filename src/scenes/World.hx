package scenes;

import h2d.Layers;
import ui.Hud;
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
  public var entityLayer: Layers;
  public var hudLayer: Layers;
  public var hud: Hud;
  public var player: Player;
  public var foods: Array<Food> = [];
  public var score: Int = 0;
  public var snakeTick: haxe.Timer;
  public var foodTick: haxe.Timer;
  public var gridSize = 16;
  public var snakeSpeed = 1;
  public var isGameover = false;

  public var boardWidth: Int;
  public var boardHeight: Int;

  var bodyParts: Array<Body> = [];

  public function setupConsole() {
    var consoleFont = DefaultFont.get().clone();
    console = new Console(consoleFont, this);
    console.addCommand("addSegment", "Add another segment to the snake", [], () -> {
      addBody();
    });
  }

  public override function init() {
    boardWidth = width;
    boardHeight = height;
    drawBackground();
    entityLayer = new Layers(this);
    addPlayer();
    addHud();
    setupConsole();
    foodTick = new haxe.Timer(66);
    snakeTick = new haxe.Timer(66);
    snakeTick.run = moveSnake;
    foodTick.run = addFood;
  }

  public function drawBackground() {
    var graphics = new h2d.Graphics(this);
    var cols = Math.floor(boardWidth / gridSize);
    var rows = Math.floor(boardHeight / gridSize);

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
        graphics.drawRect(x * gridSize, y * gridSize, gridSize, gridSize);
      }
    }
    graphics.endFill();
  }

  public function addHud() {
    hudLayer = new Layers(this);
    hudLayer.ysort(1);
    hud = new Hud(0, 0, boardWidth, boardHeight, hudLayer);
    hud.onRetry = onRetryPressed;
    hud.onToTitle = onToTitlePressed;
  }

  public function addPlayer() {
    player = new Player(0, 0, entityLayer);
    var cols = boardWidth / gridSize;
    var rows = boardHeight / gridSize;
    var halfGrid = gridSize / 2;
    var x = (cols / 2) * gridSize - halfGrid;
    var y = (rows / 2) * gridSize - halfGrid;
    player.setPosition(x, y);
    for (index in 0...4) {
      addBody();
    }
  }

  public function addBody() {
    var prev = bodyParts[bodyParts.length - 1];
    var body: Body;
    var pos: Point;
    if (prev != null) {
      pos = getNextPosition(prev.x, prev.y, prev.direction);
      body = new Body(pos.x, pos.y, entityLayer);
      body.direction = prev.direction;
    } else {
      pos = getNextPosition(player.x, player.y, player.direction);
      body = new Body(pos.x, pos.y, entityLayer);
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
    var gridLocation = new Point(randomInt(0, boardWidth / 16 - 16), randomInt(0, boardHeight / 16 - 16));
    if (bodyParts.length > 0) {
      for (body in bodyParts) {
        var rect = body.getBounds();
        if (rect.contains(gridLocation) == false) {
          food.setPosition(gridLocation.x * gridSize, gridLocation.y * gridSize);
        }
      }
    } else {
      food.setPosition(gridLocation.x * gridSize, gridLocation.y * gridSize);
    }
    foods.push(food);
  }

  public function collides(objectA: Object, objectB: Object) {
    var rectA = objectA.getBounds();
    var pos = new Point(objectB.x, objectB.y);
    return rectA.contains(pos);
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

  public function onToTitlePressed() {
    game.changeScene(new scenes.Title());
  }

  public function onRetryPressed() {
    var i = bodyParts.length;
    while (i > 0) {
      var body = bodyParts[i - 1];
      body.remove();
      bodyParts.remove(body);
      i--;
    }
    var cols = boardWidth / gridSize;
    var rows = boardHeight / gridSize;
    var halfGrid = gridSize / 2;
    var x = (cols / 2) * gridSize - halfGrid;
    var y = (rows / 2) * gridSize - halfGrid;
    player.setPosition(x, y);

    for (index in 0...4) {
      addBody();
    }

    score = 0;
    hud.changeScore(score);
    hud.hideGameover();
    isGameover = false;
  }

  public override function update(dt: Float) {
    updateConsole();
    updateInput();
    updateCollision();
    updateSnakeBounds();
  }

  public function updateCollision() {
    if (isGameover) {
      return;
    }
    if (foods[0] != null) {
      if (collides(foods[0], player)) {
        addBody();
        Res.audio.se.pickup.play();
        score++;
        hud.changeScore(score);
        removeChild(foods[0]);
        foods.shift();
      }
    }

    for (index => body in bodyParts) {
      if (index == 0) {
        continue;
      }
      if (collides(body, player)) {
        hud.showGameover();
        isGameover = true;
        Res.audio.se.lose.play();
      }
    }
  }

  public function updateSnakeBounds() {
    if (player.x < 0) {
      player.setPosition(player.x + boardWidth, player.y);
    }
    if (player.y < 0) {
      player.setPosition(player.x, player.y + boardHeight);
    }
    if (player.x > boardWidth) {
      player.setPosition(player.x - boardWidth, player.y);
    }
    if (player.y > boardHeight) {
      player.setPosition(player.x, player.y - boardHeight);
    }
  }

  private function moveSnake() {
    if (console.isActive() == true || hud.isGameoverVisible()) {
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
    if (Key.isPressed(Key.W) && player.direction != Down) {
      player.direction = Up;
    }
    if (Key.isPressed(Key.S) && player.direction != Up) {
      player.direction = Down;
    }
    if (Key.isPressed(Key.A) && player.direction != Right) {
      player.direction = Left;
    }
    if (Key.isPressed(Key.D) && player.direction != Left) {
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
