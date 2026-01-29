class TimerAlert {
  final String id;
  final Duration time;
  bool hasTriggered;

  TimerAlert({
    required this.id,
    required this.time,
    this.hasTriggered = false,
  });

  TimerAlert copyWith({
    String? id,
    Duration? time,
    bool? hasTriggered,
  }) {
    return TimerAlert(
      id: id ?? this.id,
      time: time ?? this.time,
      hasTriggered: hasTriggered ?? this.hasTriggered,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seconds': time.inSeconds,
      'hasTriggered': hasTriggered,
    };
  }

  factory TimerAlert.fromJson(Map<String, dynamic> json) {
    return TimerAlert(
      id: json['id'] as String,
      time: Duration(seconds: json['seconds'] as int),
      hasTriggered: json['hasTriggered'] as bool? ?? false,
    );
  }
}
