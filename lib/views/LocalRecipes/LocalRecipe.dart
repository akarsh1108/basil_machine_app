import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_basil/widgets/CustomAppbar.dart';
import 'package:machine_basil/widgets/locaLRecipeCard.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LocalRecipeScreen extends StatefulWidget {
  const LocalRecipeScreen({super.key});

  @override
  State<LocalRecipeScreen> createState() => _LocalRecipeScreenState();
}

class _LocalRecipeScreenState extends State<LocalRecipeScreen> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final List<Map<String, dynamic>> localRecipes = [
    {'name': 'Strawberry Shake',  'url': 'assets/local/strawberry.png'},
    {'name': 'Berrylicious Smoothie',  'url': 'assets/local/Berrilicious.png'},
    {'name': 'Guiltree Avocado Smoothie',  'url': 'assets/local/Avacado.png'},
    {'name': 'Berry Ice Tea',  'url': 'assets/local/BerryIce.png'},
    {'name': 'Choco Brownie Shake',  'url': 'assets/local/Choco.png'},
    {'name': 'Classic Cold Coffee',  'url': 'assets/local/ClassicCold.png'},
    {'name': 'Pineapple Cooler',  'url': 'assets/local/Pineapple.png'},
    {'name': 'Berry Banana Smoothie',  'url': 'assets/local/BerryBanana.png'},
    {'name': 'Peach Iced Tea',  'url': 'assets/local/PeachIceTea.png'},
  ];
  final String _webSocketUrl = 'ws://192.168.0.65:3003';

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = IOWebSocketChannel.connect(_webSocketUrl);
    _channel.stream.listen((event) {
      setState(() {
        _isConnected = true;
      });
    }, onDone: () {
      setState(() {
        _isConnected = false;
      });
    });
  }

  void _reconnect() {
    _channel.sink.close();
    _connectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.06),
          CustomAppBar(
            onReconnect: _reconnect,
            isConnected: _isConnected,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.04),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Local',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .displayLarge!
                            .copyWith(fontSize: 20),
                      ),
                      TextSpan(
                        text: ' Recipes',
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                'assets/curvedLine.png',
                width: screenWidth * 0.10,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.75,
              ),
              itemCount: localRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return LocalRecipeCard(
                  name: localRecipes[index]['name'],
                  imageUrl: localRecipes[index]['url'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
