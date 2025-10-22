import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import '../models/ir_command.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String? _deviceId;
  // Use localhost for web, 10.0.2.2 for Android emulator
  String _serverUrl = kIsWeb ? 'ws://localhost:8080' : 'ws://10.0.2.2:8080';
  final Logger _logger = Logger();
  
  // Stream controller to broadcast commands
  final StreamController<IRCommand> _commandController = StreamController<IRCommand>.broadcast();
  
  List<String> _logs = [];

  bool get isConnected => _isConnected;
  String? get deviceId => _deviceId;
  String get serverUrl => _serverUrl;
  List<String> get logs => _logs;

  void setServerUrl(String url) {
    _serverUrl = url;
    notifyListeners();
  }

  Future<void> connect() async {
    try {
      _addLog('Connecting to $_serverUrl...');
      
      _channel = WebSocketChannel.connect(Uri.parse(_serverUrl));
      
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          _addLog('WebSocket error: $error');
          _isConnected = false;
          notifyListeners();
        },
        onDone: () {
          _addLog('WebSocket disconnected');
          _isConnected = false;
          _deviceId = null;
          notifyListeners();
        },
      );

      _isConnected = true;
      _addLog('Connected successfully!');
      notifyListeners();
    } catch (e) {
      _addLog('Connection failed: $e');
      _isConnected = false;
      notifyListeners();
      rethrow;
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String);
      _addLog('Received: ${data['type']}');
      
      if (data['type'] == 'CONNECTION_SUCCESS') {
        _deviceId = data['deviceId'];
        _addLog('Device ID: $_deviceId');
      } else {
        // Broadcast command to listeners
        try {
          final command = IRCommand.fromJson(data);
          _commandController.add(command);
          _addLog('📨 Command broadcasted: ${command.type}');
        } catch (e) {
          _addLog('⚠️ Not a valid command: $e');
        }
      }
      
      // Notify listeners about new command
      notifyListeners();
    } catch (e) {
      _addLog('Error parsing message: $e');
    }
  }

  void sendResponse(String type, bool success, {String? error}) {
    if (!_isConnected || _channel == null) {
      _addLog('Cannot send response: not connected');
      return;
    }

    final response = {
      'type': type,
      'success': success,
      'timestamp': DateTime.now().toIso8601String(),
      if (error != null) 'error': error,
    };

    _channel!.sink.add(jsonEncode(response));
    _addLog('Sent response: $type (${success ? "success" : "failed"})');
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split('.')[0];
    _logs.insert(0, '[$timestamp] $message');
    if (_logs.length > 100) {
      _logs.removeLast();
    }
    _logger.i(message);
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    _deviceId = null;
    _addLog('Disconnected from server');
    notifyListeners();
  }

  Stream<IRCommand> get commandStream => _commandController.stream;

  @override
  void dispose() {
    _commandController.close();
    disconnect();
    super.dispose();
  }
}
