import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:machine_basil/widgets/curvedLine.dart';
import 'package:machine_basil/widgets/waveCard.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../../provider/web_socket_channel_html.dart';
import '../../widgets/CustomAppbar.dart';

class HomeScreen extends StatefulWidget {
  final String? drinkName;
  const HomeScreen({super.key, this.drinkName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  bool isLoading = false;
  bool _showSuccessScreen = false;
  final String _webSocketUrl = 'ws://192.168.0.65:3003';
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

    if (widget.drinkName != null) {
      _drinkName = widget.drinkName;
      _sendStartProcessing();
    }
  }

  void _connectWebSocket() {
    _channel = IOWebSocketChannel.connect(_webSocketUrl);
    _channel.stream.listen(
          (event) {
        _updateConnectionStatus(true);
        final decodedEvent = jsonDecode(event);

        if (decodedEvent['event'] == 'scanned-sachet') {
          setState(() {
            _drinkName = decodedEvent['data']['drinkName'];
            _showScanner = false;
          });
        }
        if (decodedEvent['event'] == 'error_logs') {
          _showSnackBar2(decodedEvent['data']['message']);
        }
        if (decodedEvent['event'] == 'station1') {
          setState(() {
            String currentStage = decodedEvent['data']['stage'];
            stationStages['station1'] = currentStage;
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
            stationStages['station2'] = currentStage;
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
        print("WebSocket Error: $error");
      },

    onDone: () {
        _updateConnectionStatus(false);
        print("WebSocket connection closed.");
      },
    );
  }

  void _updateConnectionStatus(bool status) {
    setState(() {
      _isConnected = status;
    });
  }

  Future<void> _sendStartProcessing() async {
    setState(() {
      isLoading = true;
    });

    final String apiUrl = 'http://192.168.0.65:3001/recipe_to_local';
    final drinkName = _drinkName;

    if (drinkName != null) {
      final Uri uri = Uri.parse('$apiUrl?recipe=$drinkName');

      try {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          setState(() {
            _showSuccessScreen = true;
          });
          // Hide success screen after 5 seconds
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              _showSuccessScreen = false;
            });
          });
        } else {
          _showSnackBar("Failed to start processing: ${response.statusCode}");

        }
      } catch (e) {
        _showSnackBar("Error occurred: $e");

      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSnackBar2(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 120),
      ),
    );
  }


  void _reconnect() {
    _channel.sink.close();
    _connectWebSocket();
  }

  bool get isAnyStationVacant {
    return stationStages.values.contains('vacant');
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
      {'name': 'Milk', 'quantity': '10000', 'url': 'assets/liquids/milkFrame.png'},
      {'name': 'Water', 'quantity': '10000', 'url': 'assets/liquids/waterFrame.png'},
      {'name': 'Curd', 'quantity': '10000', 'url': 'assets/liquids/curdFrame.png'},
      {'name': 'Kool-M', 'quantity': '10000', 'url': 'assets/liquids/koolMFrame.png'}
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
           Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.06),
              CustomAppBar(
                onReconnect: _reconnect,
                isConnected: _isConnected,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.06),
              Row(
                children: [
                  Expanded(
                    child: _showSuccessScreen
                        ? Center(
                      child: Container(

                        child: Image.asset(
                          'assets/OrderPlaced.png',
                          width: screenWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                        :Container(
                      height: 300,
                      child: _showScanner
                          ? Stack(
                        children: [
                          Positioned(
                            top: screenHeight * 0.04,
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
                                      .copyWith(fontWeight: FontWeight.normal),
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
                      )
                          : Column(
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
                            onPressed: isAnyStationVacant
                                ? () {
                              _sendStartProcessing();
                              setState(() {
                                _showScanner = true;
                              });
                            }
                                : null,
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return WaveCard(
                            name: waveCardData[index]['name'],
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
              ),
            ],
          ),
          if (isLoading)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
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
