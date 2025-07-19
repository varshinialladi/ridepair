import 'package:flutter/material.dart';
import 'package:ridetogther/screens/login_screen.dart';

class RideEnjoyableScreen extends StatefulWidget {
  const RideEnjoyableScreen({Key? key}) : super(key: key);

  @override
  State<RideEnjoyableScreen> createState() => _RideEnjoyableScreenState();
}

class _RideEnjoyableScreenState extends State<RideEnjoyableScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    // Navigate after the animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Delay briefly for better UX
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Main heading
                    const Text(
                      'Making Your\nRide Enjoyable',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Subtitle
                    const Text(
                      'Expert drivers at work. we will pick you\nin less time from your exact location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 123, 120, 120),
                        height: 1.4,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Road and car illustration
                    Container(
                      height: 300,
                      child: Stack(
                        children: [
                          // Road illustration
                          CustomPaint(
                            size: const Size(double.infinity, 300),
                            painter: RoadPainter(),
                          ),

                          // Cars
                          Positioned(
                            bottom: 80,
                            left: 50,
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.directions_car,
                                  color: Color(0xFF1A1A1A),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 40,
                            right: 80,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.directions_car,
                                  color: Color(0xFF1A1A1A),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Center navigation button
                          Positioned(
                            bottom: 120,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD700),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.navigation,
                                  color: Color(0xFFFFD700),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dashedPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw road curves
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);

    // Draw dashed center line
    final centerPath = Path();
    centerPath.moveTo(size.width * 0.1, size.height * 0.75);
    centerPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.55,
      size.width * 0.65,
      size.height * 0.72,
    );

    // Draw dashed line effect
    final pathMetrics = centerPath.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + 10);
        canvas.drawPath(segment, dashedPaint);
        distance += 20;
      }
    }

    // Draw side road lines
    final sidePath1 = Path();
    sidePath1.moveTo(size.width * 0.05, size.height * 0.9);
    sidePath1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.55,
      size.height * 0.8,
    );
    canvas.drawPath(sidePath1, paint);

    final sidePath2 = Path();
    sidePath2.moveTo(size.width * 0.65, size.height * 0.6);
    sidePath2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.7,
      size.width * 0.95,
      size.height * 0.3,
    );
    canvas.drawPath(sidePath2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Usage in your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RideEnjoyableScreen(),
    );
  }
}

void main() {
  runApp(MyApp());
}
