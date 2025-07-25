import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/detect_cubit.dart';
import 'model/state.dart';
import 'plant_health.dart';

class DiseaseDiagnosisScreen extends StatefulWidget {
  const DiseaseDiagnosisScreen({super.key});

  @override
  State<DiseaseDiagnosisScreen> createState() => _DiseaseDiagnosisScreenState();
}

class _DiseaseDiagnosisScreenState extends State<DiseaseDiagnosisScreen> {
  CameraController? _cameraController;
  Timer? _timer;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    startLivePrediction(context.read<DiseaseDetectionCubit>());
  }

  Future<void> startLivePrediction(DiseaseDetectionCubit cubit) async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
      if (!mounted) return;
      setState(() {});

      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (!isProcessing) {
          isProcessing = true;
          try {
            final image = await _cameraController!.takePicture();
            final File imageFile = File(image.path);
            await cubit.detectDiseaseFromFile(imageFile);
          } catch (e) {
            print("❌ Error capturing image: $e");
          }
          isProcessing = false;
        }
      });
    } catch (e) {
      print("📷 Camera error: $e");
    }
  }

  void stopLivePrediction() {
    _timer?.cancel();
    _cameraController?.dispose();
    print("🛑 Live prediction stopped");
  }

  @override
  void dispose() {
    stopLivePrediction();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff144937)),
          onPressed: () {
            stopLivePrediction(); // نوقف الكاميرا حتى لو رجع بالسهم
            Navigator.pop(context);
          },
        ),
        title: const Text('PlantCare AI',
            style: TextStyle(color: Color(0xff144937), fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DiseaseDetectionCubit, DiseaseDetectionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Disease Diagnosis',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff144937)),
                ),
                const SizedBox(height: 20),

                // Live camera preview
                if (_cameraController != null && _cameraController!.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                const SizedBox(height: 20),

                if (state is DiseaseLoading)
                  const Center(child: CircularProgressIndicator()),

                if (state is DiseaseSuccess) ...[
                  Text(
                    state.result.diseaseClean,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff7a1d1d)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Recommendations',
                      style: TextStyle(fontSize: 22, color: Color(0xff144937))),
                  const SizedBox(height: 10),
                  Text(
                    state.result.recommendation,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],

                if (state is DiseaseFailure)
                  Text('Error: ${state.error}',
                      style: const TextStyle(color: Colors.red)),

                const Spacer(),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      stopLivePrediction(); // 👈 هنا وقف الكاميرا والتايمر
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlantHealthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff144937),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Dismiss',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
