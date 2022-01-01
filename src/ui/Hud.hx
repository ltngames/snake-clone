package ui;

import core.Sprite;
import h2d.Object;
import hxd.res.DefaultFont;
import h2d.Text;

class Hud extends Sprite {
  public var scoreText: Text;

  public function new(x, y, parent) {
    super(x, y, null, false, parent);
    var font = DefaultFont.get().clone();
    scoreText = new Text(font, this);
    scoreText.setPosition(0, 0);
    changeScore(0);
  }

  public function changeScore(value: Int) {
    scoreText.text = Std.string('Score: ${value}');
  }
}
