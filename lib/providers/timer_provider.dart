import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/timer_alert.dart';

enum TimerState { idle, running, paused, finished }

class TimerProvider extends ChangeNotifier {
  TimerState _state = TimerState.idle;
  Duration _totalDuration = const Duration(minutes: 10);
  Duration _remainingTime = const Duration(minutes: 10);
  List<TimerAlert> _alerts = [];
  Timer? _timer;
  
  // Settings
  bool _isSoundEnabled = true;
  bool _isDarkMode = true;
  bool _isFlashing = false;
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Getters
  TimerState get state => _state;
  Duration get totalDuration => _totalDuration;
  Duration get remainingTime => _remainingTime;
  List<TimerAlert> get alerts => List.unmodifiable(_alerts);
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isDarkMode => _isDarkMode;
  bool get isFlashing => _isFlashing;
  
  double get progress {
    if (_totalDuration.inSeconds == 0) return 0;
    return _remainingTime.inSeconds / _totalDuration.inSeconds;
  }

  TimerProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    _isDarkMode = prefs.getBool('dark_mode') ?? true;
    
    // Load saved alerts
    final alertsJson = prefs.getString('alerts');
    if (alertsJson != null) {
      final List<dynamic> decoded = jsonDecode(alertsJson);
      _alerts = decoded.map((json) => TimerAlert.fromJson(json)).toList();
    }
    
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
    await prefs.setBool('dark_mode', _isDarkMode);
    
    // Save alerts
    final alertsJson = jsonEncode(_alerts.map((a) => a.toJson()).toList());
    await prefs.setString('alerts', alertsJson);
  }

  void setTotalDuration(Duration duration) {
    if (_state == TimerState.idle) {
      _totalDuration = duration;
      _remainingTime = duration;
      notifyListeners();
    }
  }

  void addAlert(Duration time) {
    if (time <= _totalDuration) {
      final alert = TimerAlert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: time,
      );
      _alerts.add(alert);
      _alerts.sort((a, b) => b.time.compareTo(a.time)); // Sort descending
      _saveSettings();
      notifyListeners();
    }
  }

  void removeAlert(String id) {
    _alerts.removeWhere((alert) => alert.id == id);
    _saveSettings();
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    _saveSettings();
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    _saveSettings();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }

  void start() {
    if (_state == TimerState.idle || _state == TimerState.paused) {
      _state = TimerState.running;
      WakelockPlus.enable(); // Keep screen on
      
      // Reset alert triggers if starting from idle
      if (_remainingTime == _totalDuration) {
        for (var alert in _alerts) {
          alert.hasTriggered = false;
        }
      }
      
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
      notifyListeners();
    }
  }

  void pause() {
    if (_state == TimerState.running) {
      _state = TimerState.paused;
      _timer?.cancel();
      WakelockPlus.disable();
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _state = TimerState.idle;
    _remainingTime = _totalDuration;
    _isFlashing = false;
    
    // Reset all alert triggers
    for (var alert in _alerts) {
      alert.hasTriggered = false;
    }
    
    WakelockPlus.disable();
    notifyListeners();
  }

  void _onTick(Timer timer) {
    if (_remainingTime.inSeconds > 0) {
      _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
      
      // Check alerts
      _checkAlerts();
      
      notifyListeners();
    } else {
      // Timer finished
      _onTimerFinished();
    }
  }

  void _checkAlerts() {
    for (var alert in _alerts) {
      if (!alert.hasTriggered && _remainingTime <= alert.time) {
        alert.hasTriggered = true;
        _triggerAlert(isFinish: false);
      }
    }
  }

  Future<void> _onTimerFinished() async {
    _timer?.cancel();
    _state = TimerState.finished;
    await _triggerAlert(isFinish: true);
    
    // Keep flashing until reset
    _startFlashing();
    
    notifyListeners();
  }

  Future<void> _triggerAlert({required bool isFinish}) async {
    // Vibrate
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [0, 500, 200, 500, 200, 500],
        intensities: [0, 255, 0, 255, 0, 255],
      );
    }
    
    // Play sound
    if (_isSoundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('sounds/alert.mp3'));
      } catch (e) {
        debugPrint('Error playing sound: $e');
      }
    }
    
    // Trigger flash animation
    _flashScreen();
  }

  void _flashScreen() {
    _isFlashing = true;
    notifyListeners();
    
    Timer(const Duration(milliseconds: 300), () {
      _isFlashing = false;
      notifyListeners();
    });
  }

  void _startFlashing() {
    // Continuous flashing for finished state
    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_state != TimerState.finished) {
        timer.cancel();
        return;
      }
      
      _isFlashing = !_isFlashing;
      notifyListeners();
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    WakelockPlus.disable();
    super.dispose();
  }
}
