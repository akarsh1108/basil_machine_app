import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machine_basil/widgets/curvedLine.dart';
import 'package:machine_basil/widgets/waveCard.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../provider/web_socket_channel_html.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final String _webSocketUrl = 'ws://localhost:8081';
  String? _drinkName;
  bool _showScanner = true;

  Map<String, String> stationStages = {
    'station1': 'vacant',
    'station2': 'vacant',
  };

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = createWebSocketChannel(_webSocketUrl);

    _channel.stream.listen(
          (event) {
        _updateConnectionStatus(true);

        // Decode the JSON-encoded event message
        final decodedEvent = jsonDecode(event);

        // Check if the event type is 'scanned-sachet'
        if (decodedEvent['event'] == 'scanned-sachet') {
          setState(() {
            _drinkName = decodedEvent['data']['drinkName']; // Access drinkName correctly
            _showScanner = false;
          });
        }
        if (decodedEvent['event'] == 'station1') {
          setState(() {
            String currentStage = decodedEvent['data']['stage'];

            // Update station1's stage
            stationStages['station1'] = currentStage;

            // If stage is "completed", reset to "vacant" after a delay
            if (currentStage == 'completed') {
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  stationStages['station1'] = 'vacant';
                });
              });
            }
          });
        }
        if (decodedEvent['event'] == 'station2') {
          setState(() {
            String currentStage = decodedEvent['data']['stage'];

            // Update station2's stage
            stationStages['station2'] = currentStage;

            // If stage is "completed", reset to "vacant" after a delay
            if (currentStage == 'completed') {
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  stationStages['station2'] = 'vacant';
                });
              });
            }
          });
        }
      },


      onError: (error) {
        _updateConnectionStatus(false);
        print("WebSocket Error: $error"); // For debugging
      },
      onDone: () {
        _updateConnectionStatus(false);
        print("WebSocket connection closed."); // For debugging
      },
    );
  }
  void _updateConnectionStatus(bool status) {
    setState(() {
      _isConnected = status;
    });
  }

  void _sendStartProcessing() {
    final message = jsonEncode(
        {'event': 'start-processing',
      'data': {'drinkName': _drinkName} });
    _channel.sink.add(message);
  }

  void _reconnect() {
    _channel.sink.close();
    _connectWebSocket();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Map<String, dynamic>> waveCardData = [
      {
        'name': 'Milk',
        'quantity': '10000',
        'url': 'assets/liquids/milkFrame.png'
      },
      {
        'name': 'Water',
        'quantity': '10000',
        'url': 'assets/liquids/waterFrame.png'
      },
      {
        'name': 'Curd',
        'quantity': '10000',
        'url': 'assets/liquids/curdFrame.png'
      },
      {
        'name': 'Kool-M',
        'quantity': '10000',
        'url': 'assets/liquids/koolMFrame.png'
      }
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: <Widget>[
          Padding(
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
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.01),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 16),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.35,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/basilLogo.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, size: 16),
                          onPressed: _reconnect,
                          color: _isConnected ? Colors.green : Colors.red,
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
          ),
          SizedBox(height: screenHeight * 0.06),
          Row(
            children: [
              Expanded(
                child: Container(
                  height:
                      300, // Fixed height for Stack container to avoid collapsing
                  child: _showScanner
                      ? Stack(
                    children: [
                      Positioned(
                        top: screenHeight *
                            0.04, // Slightly increase to position the image better
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/scanImage.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              'let\'s scan the\ningredient',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge,
                            ),
                          ),
                          Center(
                            child: Text(
                              'sachet',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Image.asset(
                            'assets/curvedLine.png',
                            width: screenWidth * 0.18,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )
                    ],
                  ):Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _drinkName ?? 'Unknown Drink',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            ElevatedButton(
                              onPressed: () {
                                _sendStartProcessing();
                                setState(() {
                                  _showScanner = true;
                                });
                              },
                              child: const Text('Start'),
                            ),
                          ],
                        ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: screenHeight * 0.5,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return WaveCard(
                        name: waveCardData[index]['name'],
                        quantity: waveCardData[index]['quantity'],
                        url: waveCardData[index]['url'],
                      );
                    },
                    itemCount: 4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.06),
          Row(
            children: [
              for (var i = 1; i <= 2; i++)
                Expanded(
                  child: Container(
                    height: screenHeight * 0.2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0E0E0E),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x83a5a5a5),
                          offset: Offset(0, 1),
                          blurRadius: 6.8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenHeight * 0.03),
                      child: Container(
                        width: screenHeight * 0.13,
                        height: screenHeight * 0.13,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x66EEEEEE),
                              offset: Offset(0, 8.67),
                              blurRadius: 34.68,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Station $i',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displayMedium,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                stationStages['station$i'] ?? 'vacant',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displayMedium!
                                    .copyWith(fontWeight: FontWeight.w200),
                              ),
                              Image.asset(
                                'assets/curvedLineBlack.png',
                                width: screenWidth * 0.1,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
          // Remaining UI elements as per your code
        ],
      ),
    );
  }
}
