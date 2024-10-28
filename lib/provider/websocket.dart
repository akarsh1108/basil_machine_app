// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
//
// class WebSocketProvider with ChangeNotifier {
//   late IOWebSocketChannel _channel;
//   bool _isConnected = false;
//   final String _webSocketUrl = 'wss://your-websocket-url.com';
//
//   bool get isConnected => _isConnected;
//
//   WebSocketProvider() {
//     _connectWebSocket();
//   }
//
//   void _connectWebSocket() {
//     _channel = IOWebSocketChannel.connect(_webSocketUrl);
//
//     _channel.stream.listen(
//           (event) {
//         _updateConnectionStatus(true);
//       },
//       onError: (error) {
//         _updateConnectionStatus(false);
//       },
//       onDone: () {
//         _updateConnectionStatus(false);
//       },
//     );
//   }
//
//   void _updateConnectionStatus(bool status) {
//     _isConnected = status;
//     notifyListeners();
//   }
//
//   void reconnect() {
//     _channel.sink.close();
//     _connectWebSocket();
//   }
//
//   @override
//   void dispose() {
//     _channel.sink.close();
//     super.dispose();
//   }
// }
