import hxd.Window;
import hxd.System;
import haxe.Json;

using StringTools;

typedef Config = {
  name: String,
  version: String,
  width: Int,
  height: Int
}

class Utils {
  public static function getSystemData() {
    var data = Res.data.system.entry.getText();
    var config: Config = Json.parse(data);
    return config;
  }

  public static function getVersion(): String {
    var data = getSystemData();
    return data.version;
  }

  public static function getPlatform(): String {
    var platform = System.platform;

    switch (platform) {
      case IOS:
        return "IOS";
      case Android:
        return "Android";
      case WebGL:
        return "Web";
      case PC:
        return "Desktop";
      case _:
        return "Other";
    }
  }

  public static function isNwjs(): Bool {
    var nwExists = true;
    try {
      nwExists = untyped nw;
    } catch (error) {
      if (error.message.contains('not defined')) {
        nwExists = false;
      }
    }
    return nwExists;
  }

  public static function resize(width: Int, height: Int, ?ignoreDpi = false) {
    #if web
    var pixelRatio = js.Browser.window.devicePixelRatio;
    var canvas = @:privateAccess Window.getInstance().canvas;

    if (pixelRatio > 1 && ignoreDpi == true) {
      width = Math.floor(width / pixelRatio);
      height = Math.floor(height / pixelRatio);
    }

    canvas.style.width = '${width}px';
    canvas.style.height = '${height}px';

    if (isNwjs()) {
      untyped nw.Window.get().resizeTo(width, height);
    }
    #end

    Window.getInstance().resize(width, height);
  }
}
