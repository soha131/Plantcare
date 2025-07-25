import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/register.dart';
import 'plant_health.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updatePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xff487852)
                : Colors.grey[400],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // أبعاد الشاشة
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => _updatePage(page),
        children: [
          // Splash Screen 1
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/plantcare.png',
                    height: height * 0.4, // 40% من ارتفاع الشاشة
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: height * 0.08), // مسافة ديناميكية
                  _buildDotsIndicator(),
                ],
              ),
            ),
          ),

          // Splash Screen 2
          Container(
            color: const Color(0xff0c3328),
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/plant.jpg',
                    height: height * 0.2, // 20% من ارتفاع الشاشة
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    'PlantCare AI',
                    style: TextStyle(
                      fontSize: width * 0.1, // حجم النص بالنسبة لعرض الشاشة
                      fontWeight: FontWeight.bold,
                      color: Colors.green[50],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Welcome to PlantCare AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.08,
                      color: Colors.green[50],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    child: Text(
                      'Monitor your plant\'s health with \n real-time insights and alerts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.06,
                        color: Colors.green[50],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.12),
                  _buildDotsIndicator(),
                  SizedBox(height: height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // مسجل دخول
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PlantHealthScreen()),
                        );
                      } else {
                        // مش مسجل
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE4EFE7),
                      minimumSize: Size(width * 0.7, height * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: width * 0.07,
                        color: const Color(0xff173b1f),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
