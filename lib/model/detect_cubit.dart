import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_auth/firebase_auth.dart'; // لو هتستخدم Firebase Auth
import '../services/api_service.dart';
import 'model.dart';
import 'state.dart';

class DiseaseDetectionCubit extends Cubit<DiseaseDetectionState> {
  DiseaseDetectionCubit() : super(DiseaseInitial());

  final String apiUrl = 'https://plant-disease-ga28.onrender.com/predict';


  Future<void> detectDiseaseFromCapturedImage() async {
    try {
      emit(DiseaseLoading());

      final imageFile = await ApiService.captureImageAndSave(); // بدون sessionCookie

      if (imageFile == null) {
        emit(DiseaseFailure("Image capture failed"));
        return;
      }


      final response = await ApiService.predictFromImage(imageFile);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final result = DiseaseDetectionModel.fromJson(jsonData);

        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          await FirebaseFirestore.instance.collection('disease_detections').add({
            'userId': userId,
            'disease_class': result.diseaseClass,
            'recommendation': result.recommendation,
            'image_path': imageFile.path,
            'timestamp': FieldValue.serverTimestamp(),
          });
        } else {
          print("⚠️ User not logged in or UID is null");
        }

        emit(DiseaseSuccess(result));
      } else {
        emit(DiseaseFailure("Prediction failed: ${response.statusCode}"));
      }
    } catch (e) {

      emit(DiseaseFailure("Error: $e"));
    }
  }

}
