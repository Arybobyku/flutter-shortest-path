
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService();
  static SharedPreferences? _preferences;
  static Future<LocalStorageService> getInstance() async {

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  ///GET
  String? getStringFromPref(String key) {
    var value  = _preferences!.getString(key);
    return value;
  }

  bool? getBoolFromPref(String key) {
    var value = _preferences!.getBool(key);
    return value;
  }

  int? getIntFromPref(String key) {
    var value = _preferences!.getInt(key);
    return value;
  }

  double? getDoubleFromPref(String key) {
    var value = _preferences!.getDouble(key);
    return value;
  }

  List<String>? getStringList(String key){
    var value = _preferences!.getStringList(key);
    return value;
  }


  ///SAVE
  void saveToPref<T>(String key, T content){
    if(content is String) {
      _preferences!.setString(key, content);
    }
    if(content is bool) {
      _preferences!.setBool(key, content);
    }
    if(content is int) {
      _preferences!.setInt(key, content);
    }
    if(content is double) {
      _preferences!.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences!.setStringList(key, content);
    }
  }

  ///CHECK
  bool checkFromPref(String key) {
    var value = _preferences!.containsKey(key);
    return value;
  }

  ///REMOVE
  void removeFromPref(String key) {
    _preferences!.remove(key);
  }

  ///CLEAR
  void clearPref() {
    _preferences!.clear();
  }
}