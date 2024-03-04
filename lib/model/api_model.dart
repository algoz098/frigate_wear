import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dio/dio.dart';

const envUrl = 'http://192.168.1.11:5000';

class ApiModel with ChangeNotifier {
  String internalUrl = '';
  List<String> internalNetworks = [];
  String externalUrl = '';
  String activeCamera = '';
  bool loaded = false;

  ApiModel();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    internalUrl = prefs.getString('internalUrl') ?? envUrl;
    externalUrl = prefs.getString('externalUrl') ?? envUrl;
    internalNetworks = prefs.getStringList('internalNetworks') ?? [];
    activeCamera = prefs.getString('activeCamera') ?? '';
    loaded = true;
  }

  Future<List<String>> getCameras() async {
    try {
      final baseUrl = await getCurrentBaseUrl();
      if (baseUrl.isEmpty) throw Exception('No base URL');
      var dio = Dio();
      var response = await dio.get('$baseUrl/api/stats');
      if (response.statusCode == 200) {
        List<String> camerasName = [];
        response.data['cameras'].forEach((key, value) {
          camerasName.add(key);
        });
        return camerasName;
      } else {
        throw Exception('Failed to load cameras');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw e;
    }
  }

  getCurrentBaseUrl() async {
    final info = NetworkInfo();
    final wifiName = await info.getWifiName();
    return internalNetworks.contains(wifiName) ? internalUrl : externalUrl;
  }

  setActiveCamera(String value) async {
    activeCamera = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('activeCamera', value);
  }

  setInternalUrl(String value) async {
    internalUrl = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('internalUrl', value);
  }

  setExternallUrl(String value) async {
    externalUrl = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('externalUrl', value);
  }

  setInternalNetwork(List<String> value) async {
    internalNetworks = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('internalNetworks', internalNetworks);
  }
}
