import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/websocket_service.dart';
import '../services/ir_service.dart';
import '../models/ir_command.dart';
import 'logs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _serverUrlController = TextEditingController();
  bool _hasIrEmitter = false;
  int _currentTemp = 24;
  bool _acPower = false;
  String _currentMode = 'cool';
  
  // Store subscription to prevent multiple listeners
  StreamSubscription<IRCommand>? _commandSubscription;

  @override
  void initState() {
    super.initState();
    _checkIrEmitter();
    // Use localhost for web, 10.0.2.2 for Android emulator
    _serverUrlController.text = kIsWeb 
        ? 'ws://localhost:8080' 
        : 'ws://10.0.2.2:8080';
  }

  @override
  void dispose() {
    _commandSubscription?.cancel();
    _serverUrlController.dispose();
    super.dispose();
  }

  Future<void> _checkIrEmitter() async {
    final irService = context.read<IRService>();
    final hasIr = await irService.hasIrEmitter();
    setState(() {
      _hasIrEmitter = hasIr;
    });
    
    if (!hasIr) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ This device does not have an IR blaster'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _connect() async {
    final wsService = context.read<WebSocketService>();
    wsService.setServerUrl(_serverUrlController.text);
    
    try {
      await wsService.connect();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Connected to server'),
            backgroundColor: Colors.green,
          ),
        );
        _listenToCommands();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Connection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _listenToCommands() {
    final wsService = context.read<WebSocketService>();
    final irService = context.read<IRService>();
    
    // Cancel existing subscription to prevent duplicates
    _commandSubscription?.cancel();
    
    // Create new subscription
    _commandSubscription = wsService.commandStream.listen((IRCommand command) async {
      bool success = false;
      String? error;
      
      try {
        switch (command.type) {
          case 'SET_TEMPERATURE':
            if (command.temperature != null) {
              setState(() => _currentTemp = command.temperature!);
              success = await irService.setTemperature(command.temperature!);
            }
            break;
          case 'SET_POWER':
            if (command.power != null) {
              setState(() => _acPower = command.power!);
              success = await irService.setPower(command.power!);
            }
            break;
          case 'SET_MODE':
            if (command.mode != null) {
              setState(() => _currentMode = command.mode!);
              success = await irService.setMode(command.mode!);
            }
            break;
        }
        
        wsService.sendResponse('COMMAND_EXECUTED', success, error: error);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${command.toString()} - ${success ? "Success" : "Failed"}'),
              backgroundColor: success ? Colors.green : Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        error = e.toString();
        wsService.sendResponse('COMMAND_FAILED', false, error: error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IR Blast Controller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LogsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WebSocketService>(
        builder: (context, wsService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildConnectionCard(wsService),
                const SizedBox(height: 16),
                _buildDeviceInfoCard(wsService),
                const SizedBox(height: 16),
                _buildACControlCard(),
                const SizedBox(height: 16),
                _buildTestCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectionCard(WebSocketService wsService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  wsService.isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: wsService.isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  wsService.isConnected ? 'Connected' : 'Disconnected',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _serverUrlController,
              decoration: const InputDecoration(
                labelText: 'WebSocket Server URL',
                hintText: 'ws://10.0.2.2:8080',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              enabled: !wsService.isConnected,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use 10.0.2.2 for Android emulator localhost\nUse your computer IP for real device',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: wsService.isConnected
                  ? ElevatedButton.icon(
                      onPressed: () {
                        _commandSubscription?.cancel();
                        wsService.disconnect();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Disconnect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _connect,
                      icon: const Icon(Icons.cloud),
                      label: const Text('Connect'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard(WebSocketService wsService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildInfoRow('Device ID', wsService.deviceId ?? 'Not assigned'),
            _buildInfoRow('IR Blaster', _hasIrEmitter ? '✅ Available' : '❌ Not available'),
            _buildInfoRow('Status', wsService.isConnected ? '🟢 Online' : '🔴 Offline'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildACControlCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AC Control Panel', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Power Switch
            SwitchListTile(
              title: const Text('AC Power'),
              subtitle: Text(_acPower ? 'ON' : 'OFF'),
              value: _acPower,
              onChanged: (value) {
                setState(() => _acPower = value);
              },
            ),
            
            const Divider(),
            
            // Temperature Control
            Text('Temperature: $_currentTemp°C', style: const TextStyle(fontSize: 18)),
            Slider(
              value: _currentTemp.toDouble(),
              min: 16,
              max: 30,
              divisions: 14,
              label: '$_currentTemp°C',
              onChanged: (value) {
                setState(() => _currentTemp = value.round());
              },
            ),
            
            const Divider(),
            
            // Mode Selection
            const Text('Mode', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['cool', 'heat', 'fan', 'dry', 'auto'].map((mode) {
                return ChoiceChip(
                  label: Text(mode.toUpperCase()),
                  selected: _currentMode == mode,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _currentMode = mode);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard() {
    final irService = context.read<IRService>();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manual Test Controls', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text('Test IR transmission without server', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _hasIrEmitter
                        ? () async {
                            final success = await irService.setTemperature(_currentTemp);
                            _showResult('Temperature', success);
                          }
                        : null,
                    icon: const Icon(Icons.thermostat),
                    label: const Text('Test Temp'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _hasIrEmitter
                        ? () async {
                            final success = await irService.setPower(_acPower);
                            _showResult('Power', success);
                          }
                        : null,
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('Test Power'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _hasIrEmitter
                    ? () async {
                        final success = await irService.setMode(_currentMode);
                        _showResult('Mode', success);
                      }
                    : null,
                icon: const Icon(Icons.tune),
                label: const Text('Test Mode'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(String action, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: ${success ? "Transmitted" : "Failed"}'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
