import 'dart:ui';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:machine_basil/widgets/CustomAppbar.dart';
import 'package:machine_basil/widgets/MachineOperation.dart';
import 'package:machine_basil/widgets/UtilitiesCardCompressed.dart';
import 'package:machine_basil/widgets/UtilitiesCardLarge.dart';
import 'package:machine_basil/widgets/locaLRecipeCard.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  bool isLoading = false;
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
      final decodedEvent = jsonDecode(event);
      if (decodedEvent['event'] == 'error_logs') {
        _showSnackBar2(decodedEvent['data']['message'], Colors.black, Colors.white);
      }
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

  Future<void> _sendApiRequest(String url) async {
    setState(() {
      isLoading = true; // Show loader
    });
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _showSnackBar('Request successful!', Colors.black, Colors.white);
      } else {
        _showSnackBar('Request failed with status: ${response.statusCode}', Colors.black, Colors.white);

      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.black, Colors.white);

    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }

  void _showSnackBar(String message, Color bgColor, Color textColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSnackBar2(String message, Color bgColor, Color textColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: textColor),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 120),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Set background to black for theme
      body: Stack(
        children: [

          Column(
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
                            text: 'Utilities',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/curvedLine.png',
                    width: screenWidth * 0.10,
                    fit: BoxFit.contain,
                    color: Colors.white, // Set image color to white for theme
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          UtilitiesCardSmall(
                            title: 'Blender Cleaning',
                            imageUrl: 'assets/blender.png',
                            onStartPressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/blender_clean');
                            },
                          ),
                          UtilitiesCardSmall(
                            title: 'Homing',
                            imageUrl: 'assets/blender.png',
                            onStartPressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/homing');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      PrimingCard(
                        title: 'Priming',
                        imageUrl: 'assets/blender.png',
                        onStartPressed: [
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=1&liqAction=start'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=2&liqAction=start'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=3&liqAction=start'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=4&liqAction=start'),
                        ],
                        onStopPressed: [
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=1&liqAction=stop'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=2&liqAction=stop'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=3&liqAction=stop'),
                              () => _sendApiRequest('http://192.168.0.65:3001/liquids?liqNum=4&liqAction=stop'),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          MachineOperationCard(
                            title: 'Machine',
                            imageUrl: 'assets/blender.png',
                            button1Label: 'stop',
                            button2Label: 'start',
                            onButton1Pressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/machineStatus?status=inactive');
                            },
                            onButton2Pressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/machineStatus?status=active');
                            },
                          ),
                          MachineOperationCard(
                            title: 'Machine',
                            imageUrl: 'assets/blender.png',
                            button1Label: 'active',
                            button2Label: 'inactive',
                            onButton1Pressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/machineStatus?status=active');
                            },
                            onButton2Pressed: () {
                              _sendApiRequest('http://192.168.0.65:3001/machineStatus?status=inactive');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.6), // Glass effect background
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white, // White loader
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
