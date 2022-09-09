import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsRepository {
  //? malumotni kalit soz orqali saqlash
  Future<bool?> saveDataToPrefs<T>({required String key, required T? data});
  //! malumotni kalit soz orqali chaqirish
  Future<T?> loadDataFromPrefs<T>({required String key});
  //? malumotni yangilash
  Future<bool> updateDataToPrefs<T>({required String? key, required T? data});
  //! malumotni db dan ochirish
  Future<bool?> deleteDataFromPrefsUsingKey({required String key});
}

class PrefsService extends PrefsRepository {
  //? Singleton
  PrefsService._private();
  static final _instance = PrefsService._private();
  factory PrefsService() => _instance;

  @override
  Future<bool?> deleteDataFromPrefsUsingKey({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  @override
  Future<T?> loadDataFromPrefs<T>({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      switch (T) {
        case String:
          return prefs.getString(key) as T;
        case double:
          return prefs.getDouble(key) as T;
        case List<String>:
          return prefs.getStringList(key) as T;
        default:
          return prefs.getString(key) as T;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  @override
  Future<bool?> saveDataToPrefs<T>(
      {required String key, required T? data}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      switch (T) {
        case String:
          return prefs.setString(key, data as String);
        case double:
          return prefs.setDouble(key, data as double);
        case List<String>:
          return prefs.setStringList(key, data as List<String>);
        default:
          return prefs.setString(key, data.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  @override
  Future<bool> updateDataToPrefs<T>({required String? key, required T? data}) {
    // TODO: implement updateDataToPrefs
    throw UnimplementedError();
  }
}
