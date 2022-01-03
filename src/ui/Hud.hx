package ui;

import hxd.res.Sound;
import hxd.Event;
import haxe.macro.Tools.TPositionTools;
import h2d.col.Bounds;
import core.Sprite;
import h2d.Object;
import hxd.res.DefaultFont;
import h2d.Text;

class Hud extends Sprite {
  private var scoreText: Text;
  private var gameoverText: Text;
  private var retryText: Text;
  private var toTileText: Text;
  private var width: Int;
  private var height: Int;
  private var uiSelect: Sound;
  private var uiOk: Sound;

  public var onRetry: () -> Void;
  public var onToTitle: () -> Void;

  public function new(x, y, width, height, parent) {
    super(x, y, null, false, parent);
    uiSelect = Res.audio.se.ui_select;
    uiOk = Res.audio.se.ui_ok;
    var font = DefaultFont.get().clone();
    font.resizeTo(26);

    scoreText = new Text(font, this);
    scoreText.setPosition(0, 0);
    changeScore(0);

    var gameoverFont = DefaultFont.get().clone();
    gameoverFont.resizeTo(40);
    gameoverText = new Text(gameoverFont, this);
    gameoverText.text = "GameOver";
    gameoverText.setPosition(width / 2 - gameoverText.textWidth / 2, height / 2 - gameoverText.textWidth / 2);

    retryText = createTextButton("Retry", 26, onRetryPressed, onOverRetry);
    retryText.setPosition(width / 2 - retryText.textWidth / 2, gameoverText.y + 80);

    toTileText = createTextButton("To Title", 26, onToTitlePressed, onOverToTitle);
    toTileText.setPosition(width / 2 - toTileText.textWidth / 2, retryText.y + 30);

    hideGameover();
  }

  public function createTextButton(title: String, size: Int, onPress, ?onOver) {
    var font = hxd.res.DefaultFont.get().clone();
    font.resizeTo(size);

    var textButton = new h2d.Text(font, this);
    textButton.text = title;

    var interaction = new h2d.Interactive(textButton.textWidth, textButton.textHeight, textButton);
    interaction.onClick = onPress;
    interaction.onOver = onOver;
    return textButton;
  }

  public function showGameover() {
    gameoverText.visible = true;
    retryText.visible = true;
    toTileText.visible = true;
  }

  public function hideGameover() {
    gameoverText.visible = false;
    retryText.visible = false;
    toTileText.visible = false;
  }

  public function isGameoverVisible(): Bool {
    return gameoverText.visible == true;
  }

  private function onRetryPressed(event: Event) {
    if (onRetry != null) {
      onRetry();
      uiOk.play();
    }
  }

  private function onToTitlePressed(event: Event) {
    if (onToTitle != null) {
      onToTitle();
      uiOk.play();
    }
  }

  private function onOverRetry(event: Event) {
    uiSelect.stop();
    uiSelect.play();
  }

  private function onOverToTitle(event: Event) {
    uiSelect.stop();
    uiSelect.play();
  }

  public function changeScore(value: Int) {
    scoreText.text = Std.string('Score: ${value}');
  }
}
