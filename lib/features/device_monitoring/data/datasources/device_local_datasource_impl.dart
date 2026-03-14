import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:plexus_noc/features/device_monitoring/data/models/device_model.dart';
import 'device_local_datasource.dart';

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final Box cacheBox;
  static const cachedDevicesKey = 'CACHED_DEVICES';

  DeviceLocalDataSourceImpl({required this.cacheBox});

  @override
  Future<void> cacheDevices(List<DeviceModel> devices) async {
    final List<Map<String, dynamic>> jsonList = devices
        .map((d) => d.toJson())
        .toList();
    final String jsonString = jsonEncode(jsonList);

    await cacheBox.put(cachedDevicesKey, jsonString);
  }

  @override
  Future<List<DeviceModel>> getLastCachedDevices() async {
    final String? jsonString = cacheBox.get(cachedDevicesKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => DeviceModel.fromJson(json)).toList();
    } else {
      throw Exception('No cached data found');
    }
  }
}
