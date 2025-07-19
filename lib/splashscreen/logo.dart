import 'package:flutter/material.dart';
import 'package:ridetogther/screens/splash.dart';

class AnimatedLogoImage extends StatefulWidget {
  @override
  _AnimatedLogoImageState createState() => _AnimatedLogoImageState();
}

class _AnimatedLogoImageState extends State<AnimatedLogoImage>
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
            MaterialPageRoute(builder: (context) => RideEnjoyableScreen()),
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
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('images/location.jpeg', height: 150),
        ),
      ),
    );
  }
}
