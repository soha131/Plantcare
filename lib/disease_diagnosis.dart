import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LiveFeedScreen.dart';
import 'model/detect_cubit.dart';
import 'model/state.dart';
import 'services/api_service.dart'; // هنعمل فيها ميثود للـ predict-from-camera

class DiseaseDiagnosisScreen extends StatefulWidget {
  const DiseaseDiagnosisScreen({super.key});

  @override
  State<DiseaseDiagnosisScreen> createState() => _DiseaseDiagnosisScreenState();
}

class _DiseaseDiagnosisScreenState extends State<DiseaseDiagnosisScreen> {
  File? capturedImage;
  bool isLoadingImage = false;

  void fetchImageAndPredict() async {
    setState(() => isLoadingImage = true);

    final imageFile = await ApiService.captureImageAndSave();

    if (imageFile != null) {
      setState(() {
        capturedImage = imageFile;
        isLoadingImage = false;
      });

      // بعد الحفظ، ابعت الصورة للتحليل
      await context
          .read<DiseaseDetectionCubit>()
          .detectDiseaseFromCapturedImage();
    } else {
      setState(() => isLoadingImage = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("فشل في تحميل الصورة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PlantCare AI',
          style: TextStyle(color: Color(0xff144937)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: Color(0xff144937)),
        actions: [
          IconButton(
            icon: const Icon(Icons.live_tv, color: Color(0xff144937)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveFeedScreen()),
              );
            },
          ),
        ],
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
                    color: Color(0xff144937),
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ مكان الصورة
                GestureDetector(
                  onTap: fetchImageAndPredict,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        isLoadingImage
                            ? const Center(child: CircularProgressIndicator())
                            : capturedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                capturedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                            : const Center(child: Text('Tap to capture image')),
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
                      color: Color(0xff7a1d1d),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recommendations',
                    style: TextStyle(fontSize: 22, color: Color(0xff144937)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.result.recommendation,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],

                if (state is DiseaseFailure)
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff144937),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Dismiss',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 28,
                      ),
                      onPressed: () async {
                        try {
                          final response = await ApiService.logout();
                          if (response.statusCode == 200) {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/login');
                          } else {
                            print('⚠️ Logout failed: ${response.statusCode}');
                          }
                        } catch (e) {
                          print('❌ Error during logout: $e');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
