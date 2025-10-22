/// AC IR Patterns
/// These are example patterns. You need to capture actual IR codes for your specific AC model.
/// Use IR learning apps or Arduino with IR receiver to capture the codes.
class ACPatterns {
  // Standard carrier frequency for most AC units
  static const int carrierFrequency = 38000;

  // Example power patterns (replace with actual codes from your AC)
  static final List<int> powerOn = [
    9000, 4500, 560, 560, 560, 1690, 560, 560, 560, 560,
    560, 1690, 560, 1690, 560, 1690, 560, 560, 560, 1690,
    560, 560, 560, 560, 560, 1690, 560, 560, 560, 560,
    560, 560, 560, 1690, 560, 1690, 560, 560, 560, 1690,
  ];

  static final List<int> powerOff = [
    9000, 4500, 560, 1690, 560, 560, 560, 1690, 560, 560,
    560, 560, 560, 1690, 560, 1690, 560, 1690, 560, 560,
    560, 1690, 560, 560, 560, 560, 560, 1690, 560, 560,
    560, 560, 560, 560, 560, 1690, 560, 1690, 560, 560,
  ];

  // Temperature patterns (16-30°C)
  // These are placeholders - replace with actual captured codes
  static final Map<int, List<int>> _temperaturePatterns = {
    16: [9000, 4500, 560, 560, 560, 560, 560, 1690, 560, 560],
    17: [9000, 4500, 560, 560, 560, 1690, 560, 560, 560, 560],
    18: [9000, 4500, 560, 560, 560, 1690, 560, 1690, 560, 560],
    19: [9000, 4500, 560, 1690, 560, 560, 560, 560, 560, 560],
    20: [9000, 4500, 560, 1690, 560, 560, 560, 1690, 560, 560],
    21: [9000, 4500, 560, 1690, 560, 1690, 560, 560, 560, 560],
    22: [9000, 4500, 560, 1690, 560, 1690, 560, 1690, 560, 560],
    23: [9000, 4500, 560, 560, 560, 560, 560, 560, 560, 1690],
    24: [9000, 4500, 560, 560, 560, 1690, 560, 560, 560, 1690],
    25: [9000, 4500, 560, 560, 560, 1690, 560, 1690, 560, 1690],
    26: [9000, 4500, 560, 1690, 560, 560, 560, 560, 560, 1690],
    27: [9000, 4500, 560, 1690, 560, 560, 560, 1690, 560, 1690],
    28: [9000, 4500, 560, 1690, 560, 1690, 560, 560, 560, 1690],
    29: [9000, 4500, 560, 1690, 560, 1690, 560, 1690, 560, 1690],
    30: [9000, 4500, 560, 560, 560, 560, 560, 560, 560, 560],
  };

  // Mode patterns
  static final Map<String, List<int>> _modePatterns = {
    'cool': [9000, 4500, 560, 560, 560, 1690, 560, 560, 560, 1690],
    'heat': [9000, 4500, 560, 1690, 560, 560, 560, 1690, 560, 560],
    'fan': [9000, 4500, 560, 1690, 560, 1690, 560, 560, 560, 560],
    'dry': [9000, 4500, 560, 560, 560, 560, 560, 1690, 560, 1690],
    'auto': [9000, 4500, 560, 1690, 560, 560, 560, 560, 560, 1690],
  };

  static List<int> getTemperaturePattern(int temperature) {
    if (temperature < 16 || temperature > 30) {
      return [];
    }
    return _temperaturePatterns[temperature] ?? [];
  }

  static List<int> getModePattern(String mode) {
    return _modePatterns[mode.toLowerCase()] ?? [];
  }

  // Helper method to convert hex string to pattern (for captured codes)
  static List<int> hexToPattern(String hex) {
    // Implement if you capture codes in hex format
    // This is a placeholder
    return [];
  }
}
