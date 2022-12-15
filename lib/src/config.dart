class Config {


  /* Replace your sire url and api keys */

  String appName = 'FastFood';
  String androidPackageName = 'com.FastFood.app';
  String iosPackageName = 'com.FastFood.app';

  String url = 'https://deliveryfastfood.com/';
  String consumerKey = 'ck_1d64d181916e72741e2dfce38835f0d81bab7867';
  String consumerSecret = 'cs_bb94e47985e72bc19f4c342e67f26b36f16d4867';
  String mapApiKey = 'AIzaSyBAcvBoEuYPDBWBuejS_dqRJKzJa0OiVak';

  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }

  dynamic get(String key) => appConfig[key];

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void clear() => appConfig.clear();

  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  add(Map<String, dynamic> map) => appConfig.addAll(map);

}