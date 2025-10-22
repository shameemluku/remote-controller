class IRCommand {
  final String type;
  final int? temperature;
  final bool? power;
  final String? mode;
  final String timestamp;

  IRCommand({
    required this.type,
    this.temperature,
    this.power,
    this.mode,
    required this.timestamp,
  });

  factory IRCommand.fromJson(Map<String, dynamic> json) {
    return IRCommand(
      type: json['type'] as String,
      temperature: json['temperature'] as int?,
      power: json['power'] as bool?,
      mode: json['mode'] as String?,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (temperature != null) 'temperature': temperature,
      if (power != null) 'power': power,
      if (mode != null) 'mode': mode,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    switch (type) {
      case 'SET_TEMPERATURE':
        return 'Set Temperature: ${temperature}°C';
      case 'SET_POWER':
        return 'Power: ${power! ? "ON" : "OFF"}';
      case 'SET_MODE':
        return 'Mode: ${mode?.toUpperCase()}';
      default:
        return 'Unknown command: $type';
    }
  }
}
