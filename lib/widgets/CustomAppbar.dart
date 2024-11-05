import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_basil/controller/MenuController.dart';

class CustomAppBar extends StatelessWidget {
  final Function onReconnect;
  final bool isConnected;
  final double screenHeight;
  final double screenWidth;
  final MenuControllers menuController = Get.find();

  CustomAppBar({
    Key? key,
    required this.onReconnect,
    required this.isConnected,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  void _openMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 60.0,bottom: 30), // Adjusts the dialog margins
            child: Container(
              width: screenWidth * 0.6,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Column(
                  children: [
                    // Logo at the top with centered alignment
                    Container(
                      height: screenHeight * 0.1,
                      child: Image.asset(
                        'assets/basilFinal.png',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    // Spacer to create space between logo and menu items
                    SizedBox(height: screenHeight * 0.04),
                    // Menu items
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _menuItem(context, Icons.home, 'Home', '/home'),
                        _menuItem(context, Icons.opacity, 'Refill', '/replenishment'),
                        _menuItem(context, Icons.restaurant_menu, 'Local Recipes', '/localRecipes'),
                        _menuItem(context, Icons.build, 'Utilities', '/utilities'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () {
        menuController.updateRoute(route);
        Navigator.of(context).pop();
        Get.toNamed(route); // Navigate to the selected route
      },
      child: Obx(() {
        bool isSelected = menuController.selectedRoute.value == route;
        return Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015,horizontal: screenWidth * 0.017),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.005),
          decoration: isSelected
              ? BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(60),
          )
              : null,
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black),
              SizedBox(width: screenWidth * 0.05),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: screenHeight * 0.03,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05),
      child: Container(
        height: screenHeight * 0.07,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(screenHeight * 0.05),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66BCBCBC),
              offset: Offset(0, 10),
              blurRadius: 40,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu, size: 16),
              onPressed: () => _openMenu(context),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/basilLogo.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, size: 16),
                    onPressed: () => onReconnect(),
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.02,
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.01),
                  child: Container(
                    height: screenHeight * 0.07,
                    width: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE7E7E7),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/appbarIcon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
