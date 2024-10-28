import 'package:flutter/material.dart';

class CurvedLineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background similar to the image
      body: Center(
        child: CustomPaint(
          size: Size(200, 100), // Adjust size as needed
          painter: CurvedLinePainter(),
        ),
      ),
    );
  }
}

class CurvedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Line color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8 // Thickness of the line
      ..style = PaintingStyle.stroke;

    // Define a path for the curve
    final path = Path();
    path.moveTo(0, size.height * 0.6); // Starting point
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.2, // Control point for the curve
      size.width, size.height * 0.8, // Endpoint of the curve
    );

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}