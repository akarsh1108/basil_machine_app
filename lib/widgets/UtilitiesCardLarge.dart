import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimingCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final List<VoidCallback> onStartPressed; // List of callbacks for each "start" button
  final List<VoidCallback> onStopPressed; // List of callbacks for each "stop" button

  const PrimingCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onStartPressed,
    required this.onStopPressed,
  })  : assert(onStartPressed.length == 4, 'Provide 4 start callbacks'),
        assert(onStopPressed.length == 4, 'Provide 4 stop callbacks'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
                width: screenWidth * 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
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

          Image.asset(
            'assets/curvedLine.png',
            width: screenWidth * 0.14,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.only(left: screenHeight*0.04,right: screenHeight*0.04),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('L1', style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('L2', style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('L3', style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('L4', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton('start', onStartPressed[0]),
                    _buildButton('start', onStartPressed[1]),
                    _buildButton('start', onStartPressed[2]),
                    _buildButton('start', onStartPressed[3]),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton('stop', onStopPressed[0]),
                    _buildButton('stop', onStopPressed[1]),
                    _buildButton('stop', onStopPressed[2]),
                    _buildButton('stop', onStopPressed[3]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
