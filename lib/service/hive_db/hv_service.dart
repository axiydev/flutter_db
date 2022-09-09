import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class HiveDbRepository {
  Box? get box;
  Future<void> get closeBox;

  //!----------------
  Future<void> saveDataToHiveBox<T>({required String? key, required T? data});
  Future<T?> loadDataFromHiveBox<T>({required String? key});
  Future<void> updateDataInHiveBox<T>({required String? key, required T? data});
  Future<void> deleteDataFromHiveBox({required String key});
}

class HiveServiceRepo extends HiveDbRepository {
  Box? _box;
  //! init hive
  HiveServiceRepo._init() {
    init();
  }
//!init hive method
  init() async {
    try {
      final directoryDb = await getApplicationDocumentsDirectory();
      Hive.init(directoryDb.path);
      _box = await Hive.openBox('data_db');
      if (kDebugMode) {
        print('HIVE INITED');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static final _instance = HiveServiceRepo._init();
  factory HiveServiceRepo() => _instance;

  @override
  Box? get box => _box;
  @override
  Future<void> get closeBox => _box!.close();

  @override
  Future<void> deleteDataFromHiveBox({required String key}) async {
    try {
      return _box!.delete(key);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<T?> loadDataFromHiveBox<T>({required String? key}) async {
    try {
      return Future.value(_box!.get(key));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  @override
  Future<void> saveDataToHiveBox<T>(
      {required String? key, required T? data}) async {
    try {
      await _box!.put(key, data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<void> updateDataInHiveBox<T>(
      {required String? key, required T? data}) {
    // TODO: implement updateDataInHiveBox
    throw UnimplementedError();
  }
}
