import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../models/ac_patterns.dart';

class IRService {
  static const platform = MethodChannel('com.example.flutter_ir_app/ir');
  final Logger _logger = Logger();

  Future<bool> hasIrEmitter() async {
    // Web doesn't support IR blaster
    if (kIsWeb) {
      _logger.i('Running on web - IR blaster not available');
      return false;
    }
    
    try {
      final bool result = await platform.invokeMethod('hasIrEmitter');
      return result;
    } on PlatformException catch (e) {
      _logger.e("Failed to check IR emitter: ${e.message}");
      return false;
    } on MissingPluginException catch (e) {
      _logger.w("Platform doesn't support IR: ${e.message}");
      return false;
    }
  }

  Future<List<Map<String, int>>?> getCarrierFrequencies() async {
    if (kIsWeb) return null;
    
    try {
      final List<dynamic>? result = await platform.invokeMethod('getCarrierFrequencies');
      return result?.map((e) => Map<String, int>.from(e)).toList();
    } on PlatformException catch (e) {
      _logger.e("Failed to get carrier frequencies: ${e.message}");
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> transmit(int frequency, List<int> pattern) async {
    if (kIsWeb) {
      _logger.i('Web platform - IR transmission simulated');
      return true; // Simulate success on web
    }
    
    try {
      final bool result = await platform.invokeMethod('transmit', {
        'frequency': frequency,
        'pattern': pattern,
      });
      _logger.i('IR signal transmitted successfully');
      return result;
    } on PlatformException catch (e) {
      _logger.e("Failed to transmit IR: ${e.message}");
      return false;
    } catch (e) {
      _logger.w("Platform doesn't support IR transmission");
      return false;
    }
  }

  Future<bool> setTemperature(int temperature) async {
    final pattern = ACPatterns.getTemperaturePattern(temperature);
    if (pattern.isEmpty) {
      _logger.w('No pattern found for temperature $temperature');
      return false;
    }
    return await transmit(38000, pattern);
  }

  Future<bool> setPower(bool on) async {
    final pattern = on ? ACPatterns.powerOn : ACPatterns.powerOff;
    return await transmit(38000, pattern);
  }

  Future<bool> setMode(String mode) async {
    final pattern = ACPatterns.getModePattern(mode);
    if (pattern.isEmpty) {
      _logger.w('No pattern found for mode $mode');
      return false;
    }
    return await transmit(38000, pattern);
  }
}
