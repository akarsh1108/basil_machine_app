import 'package:flutter/material.dart';

class WaveCard extends StatelessWidget {
  final String name;
  final String quantity;
  final String url;

  const WaveCard({
    Key? key,
    required this.name,
    required this.quantity,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenHeight * 0.3, // Adjusted width
      height: screenWidth * 0.2,  // Adjusted height

      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            quantity,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10), // Spacing between text and image
          Expanded( // Use Expanded to let the image take available space
            child: Container(
              height: double.infinity, // Full height of the parent container
              width: double.infinity, // Full width of the parent container
              child: Image.asset(
                url,
                fit: BoxFit.contain, // Ensures the entire image is shown
              ),
            ),
          ),
        ],
      ),
    );
  }
}
