import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_basil/widgets/CustomAppbar.dart';
import 'package:machine_basil/widgets/refillCard.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RefillingLiquid extends StatefulWidget {
  const RefillingLiquid({super.key});

  @override
  State<RefillingLiquid> createState() => _RefillingLiquidState();
}

class _RefillingLiquidState extends State<RefillingLiquid> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final List<Map<String, dynamic>> refilCardData = [
    {'name': 'Milk', 'quantity': '10000', 'url': 'assets/refil/milkR.png'},
    {'name': 'Water', 'quantity': '10000', 'url': 'assets/refil/waterr.png'},
    {'name': 'Curd', 'quantity': '10000', 'url': 'assets/refil/curdr.png'},
    {'name': 'Kool-M', 'quantity': '10000', 'url': 'assets/refil/koolmR.png'}
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
          SizedBox(height: screenHeight * 0.06),
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Refilling ',
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  TextSpan(
                    text: ' Liquid',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .displayLarge!
                        .copyWith(fontSize: 20),
                  ),
                  TextSpan(
                    text: ' Container',
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/curvedLine.png',
            width: screenWidth * 0.14,
            fit: BoxFit.contain,
          ),

          Expanded(
            // height: screenHeight * 0.65,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext context, int index) {
                return RefillCard(
                  name: refilCardData[index]['name'],
                  url: refilCardData[index]['url'],
                );
              },
              itemCount: refilCardData.length,
            ),
          ),
        ],
      ),
    );
  }
}
