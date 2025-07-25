/*
import 'package:flutter/material.dart';
import 'disease_diagnosis.dart';

class PlantHealthScreen extends StatelessWidget {
  final String? userName;
  const PlantHealthScreen({Key? key, this.userName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Text("Hello, ${userName ?? "User"}"),
                    Stack(
                      clipBehavior: Clip.none, // Prevent clipping of children
                      children: [
                        Positioned(
                          top: 0, // Place at the bottom of the image
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Color(0xff173b1f)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/tree.jpg',
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: -25, // Place at the bottom of the image
                          left: 0,
                          right: 0, // Span full width
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xff2f673b).withOpacity(0.9), // Slightly transparent for visibility
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2), // Shadow for visibility
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shield, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    'Healthy',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.water_drop, color: Colors.blue),
                        title: Text(
                          'Soil Moisture',
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Text(
                          '46%',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.thermostat, color: Colors.orange),
                        title: Text(
                          'Soil Temperature',
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Text(
                          '22.5°C',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.add_circle, color: Colors.blue),
                        title: Text(
                          'Disease Diagnosis',
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          'No issues detected',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiseaseDiagnosisScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2f673b),
                        minimumSize: Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'History',
                        style: TextStyle(fontSize: 28, color: Colors.white),
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
}*/
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'disease_diagnosis.dart';
import 'history_screen.dart';

class PlantHealthScreen extends StatelessWidget {
  final String? userName;
  final double soilMoistureValue = 46; // هنا بنخزن القيمة المعروضة

  const PlantHealthScreen({super.key, this.userName});

  void _checkSoilMoisture(BuildContext context, double value) {
    String message;
    if (value < 30) {
      message = 'Soil moisture is LOW';
    } else if (value > 70) {
      message = 'Soil moisture is HIGH';
    } else {
      message = 'Soil moisture is NORMAL';
    }

    Flushbar(
      message: message,
      backgroundColor: value < 30
          ? Colors.red
          : (value > 70 ? Colors.orange : Colors.green),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Color(0xff173b1f)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/tree.jpg',
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: -25,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff2f673b).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Healthy',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Card(
                child: ListTile(
                  leading: Icon(Icons.water_drop, color: Colors.blue),
                  title: Text(
                    'Soil Moisture',
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Text(
                    '${soilMoistureValue.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _checkSoilMoisture(context, soilMoistureValue),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.thermostat, color: Colors.orange),
                  title: Text(
                    'Soil Temperature',
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Text(
                    '22.5°C',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiseaseDiagnosisScreen()),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.add_circle, color: Colors.blue),
                    title: Text(
                      'Disease Diagnosis',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'No issues detected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff2f673b),
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

