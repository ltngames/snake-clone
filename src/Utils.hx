import hxd.Window;
import hxd.System;
import haxe.Json;

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
}
