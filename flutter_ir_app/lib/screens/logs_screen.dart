import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<WebSocketService>().clearLogs();
            },
          ),
        ],
      ),
      body: Consumer<WebSocketService>(
        builder: (context, wsService, child) {
          if (wsService.logs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No logs yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: wsService.logs.length,
            itemBuilder: (context, index) {
              final log = wsService.logs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(
                    _getLogIcon(log),
                    color: _getLogColor(log),
                  ),
                  title: Text(
                    log,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  dense: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getLogIcon(String log) {
    if (log.contains('✅') || log.contains('success')) return Icons.check_circle;
    if (log.contains('❌') || log.contains('error') || log.contains('failed')) {
      return Icons.error;
    }
    if (log.contains('Connecting')) return Icons.sync;
    if (log.contains('Received')) return Icons.download;
    if (log.contains('Sent')) return Icons.upload;
    return Icons.info;
  }

  Color _getLogColor(String log) {
    if (log.contains('✅') || log.contains('success')) return Colors.green;
    if (log.contains('❌') || log.contains('error') || log.contains('failed')) {
      return Colors.red;
    }
    if (log.contains('Connecting')) return Colors.blue;
    return Colors.grey;
  }
}
