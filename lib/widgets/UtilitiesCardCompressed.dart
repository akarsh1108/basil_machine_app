import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UtilitiesCardSmall extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onStartPressed;

  const UtilitiesCardSmall({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with rounded corners
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              border: Border.all(color: const Color(0xFFE9E9E9), width: 0.20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66BCBCBC), // Lower opacity for a lighter shadow
                  offset: Offset(0, 2), // Reduced offset for less spread
                  blurRadius: 10, // Reduced blur radius for a tighter shadow
                ),
              ],
              borderRadius: BorderRadius.circular(36),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Image.asset(
                imageUrl,
                height: screenHeight * 0.2,
                width: screenWidth * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.015),
          // Title text
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          // Start button
          ElevatedButton(
            onPressed: onStartPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.14,
                vertical: 6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'start',
              style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
                color: const Color(0xFF0E0E0E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
