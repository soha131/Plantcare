import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_auth/firebase_auth.dart'; // لو هتستخدم Firebase Auth

import 'model.dart';
import 'state.dart';

class DiseaseDetectionCubit extends Cubit<DiseaseDetectionState> {
  DiseaseDetectionCubit() : super(DiseaseInitial());

  final String apiUrl = 'https://plant-disease-ga28.onrender.com/predict';

  Future<void> detectDiseaseFromFile(File imageFile) async {
    try {
      emit(DiseaseLoading());

      final client = http.Client();
      var uri = Uri.parse(apiUrl);

      print("🔁 Sending image to: $uri");

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var streamedResponse = await client.send(request);

      http.Response response;

      if (streamedResponse.statusCode == 307 || streamedResponse.statusCode == 302) {
        final redirectedUrl = streamedResponse.headers['location'];
        print("⚠️ Redirected to: $redirectedUrl");

        if (redirectedUrl != null) {
          final redirectedRequest = http.MultipartRequest('POST', Uri.parse(redirectedUrl));
          redirectedRequest.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
          final redirectedResponse = await client.send(redirectedRequest);
          response = await http.Response.fromStream(redirectedResponse);
        } else {
          emit(DiseaseFailure("Redirected without location header"));
          return;
        }
      } else {
        response = await http.Response.fromStream(streamedResponse);
      }

      print("📦 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final result = DiseaseDetectionModel.fromJson(jsonData);

        final userId = FirebaseAuth.instance.currentUser?.uid; // أو خليه argument لو مش بتستخدم Firebase Auth

        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('disease_detections')
              .add({
            'userId': userId,
            'disease_class': result.diseaseClass,
            'recommendation': result.recommendation,
            // 'disease_clean': result.diseaseClean,
            // 'status': result.status,
            'image_path': imageFile.path,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        emit(DiseaseSuccess(result));
      } else {
        emit(DiseaseFailure("Failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(DiseaseFailure("Error: $e"));
      print("🔥 Exception: $e");
    }
  }
}
