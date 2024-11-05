import 'package:flutter/material.dart';

import '../views/Home/home.dart';


class LocalRecipeCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const LocalRecipeCard({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              imageUrl,
              height: screenHeight * 0.16,
              width: screenWidth * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Recipe name
          Text(
            name,
            style: Theme.of(context).primaryTextTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          // Make button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(drinkName: name),
                ),
              );
            },
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
              'make',
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
