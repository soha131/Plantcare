import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = 'http://10.42.0.1:5000';

  static Future<http.Response> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/register');
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'username': username,
        'full_name': fullName,
        'email': email,
        'password': password,
      });


      final response = await http.post(url, headers: headers, body: body);

      return response;
    } catch (e) {
      rethrow; // عشان يوصلك برضو الخطأ في الكولر
    }
  }

  static Future<http.Response> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'username': username,

        'password': password,
      });



      final response = await http.post(url, headers: headers, body: body);


      return response;
    } catch (e) {
      rethrow; // عشان يوصلك برضو الخطأ في الكولر
    }
  }


  // Logout (if your API needs logout call)
  static Future<http.Response> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    return await http.get(url);
  }

  // Get sensor data (temperature, humidity, etc.)
  static Future<http.Response> getSensorData() async {
    final url = Uri.parse('$baseUrl/sensor');
    return await http.get(url);
  }

  // Capture image from camera
  static Future<File?> captureImageAndSave() async {
    try {
      final url = Uri.parse('$baseUrl/capture');

      final response = await http.get(url); // ❌ بدون headers
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/captured_image.jpg';
        final file = File(filePath);

        await file.writeAsBytes(bytes);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }



  // Upload an image and get prediction
  static Future<http.Response> predictFromImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/predict');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }



  // Predict from camera
  static Future<http.Response> predictFromCamera() async {
    final url = Uri.parse('$baseUrl/predict-from-camera');
    return await http.get(url);
  }



  // Live Feed URL (use it in video widget like flutter_mjpeg)
  static String getLiveFeedUrl() {
    return '$baseUrl/live-feed';
  }
}
