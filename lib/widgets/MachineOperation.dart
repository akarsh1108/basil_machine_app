import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MachineOperationCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String button1Label;
  final String button2Label;
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;

  const MachineOperationCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.button1Label,
    required this.button2Label,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.038),
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
                  color: Color(0x66BCBCBC),
                  offset: Offset(0, 5),
                  blurRadius: 15,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.015),
          // Row of stop and start buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(button1Label, onButton1Pressed,context),
              SizedBox(width: screenWidth * 0.02), // Space between buttons
              _buildButton(button2Label, onButton2Pressed,context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed,BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
        color: const Color(0xFF0E0E0E),
        fontWeight: FontWeight.w400,
      ),
      ),
    );
  }
}
