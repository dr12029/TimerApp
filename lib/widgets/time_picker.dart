import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int _hours = 0;
  int _minutes = 10;
  int _seconds = 0;
  
  final _hoursController = TextEditingController(text: '00');
  final _minutesController = TextEditingController(text: '10');
  final _secondsController = TextEditingController(text: '00');
  
  final _hoursFocus = FocusNode();
  final _minutesFocus = FocusNode();
  final _secondsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _hoursController.text = _hours.toString().padLeft(2, '0');
    _minutesController.text = _minutes.toString().padLeft(2, '0');
    _secondsController.text = _seconds.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _hoursFocus.dispose();
    _minutesFocus.dispose();
    _secondsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerProvider = context.watch<TimerProvider>();
    final isIdle = timerProvider.state == TimerState.idle;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Timer Duration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeColumn(
                  label: 'Hours',
                  value: _hours,
                  controller: _hoursController,
                  focusNode: _hoursFocus,
                  nextFocus: _minutesFocus,
                  max: 23,
                  onIncrement:
                      isIdle ? () => _updateTime(hours: _hours + 1) : null,
                  onDecrement: isIdle && _hours > 0
                      ? () => _updateTime(hours: _hours - 1)
                      : null,
                  onChanged: isIdle ? (val) => _updateTime(hours: val) : null,
                ),
                Text(':', style: theme.textTheme.headlineMedium),
                _buildTimeColumn(
                  label: 'Minutes',
                  value: _minutes,
                  controller: _minutesController,
                  focusNode: _minutesFocus,
                  nextFocus: _secondsFocus,
                  max: 59,
                  onIncrement: isIdle && _minutes < 59
                      ? () => _updateTime(minutes: _minutes + 1)
                      : null,
                  onDecrement: isIdle && _minutes > 0
                      ? () => _updateTime(minutes: _minutes - 1)
                      : null,
                  onChanged: isIdle ? (val) => _updateTime(minutes: val) : null,
                ),
                Text(':', style: theme.textTheme.headlineMedium),
                _buildTimeColumn(
                  label: 'Seconds',
                  value: _seconds,
                  controller: _secondsController,
                  focusNode: _secondsFocus,
                  max: 59,
                  onIncrement: isIdle && _seconds < 59
                      ? () => _updateTime(seconds: _seconds + 1)
                      : null,
                  onDecrement: isIdle && _seconds > 0
                      ? () => _updateTime(seconds: _seconds - 1)
                      : null,
                  onChanged: isIdle ? (val) => _updateTime(seconds: val) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn({
    required String label,
    required int value,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required int max,
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
    Function(int)? onChanged,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.keyboard_arrow_up),
          iconSize: 32,
        ),
        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && onChanged != null) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if (value < max) onChanged(value + 1);
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if (value > 0) onChanged(value - 1);
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (text) {
                  if (text.isEmpty) return;
                  int? val = int.tryParse(text);
                  if (val != null && val <= max && onChanged != null) {
                    onChanged(val);
                  }
                },
                onSubmitted: (_) {
                  if (nextFocus != null) {
                    nextFocus.requestFocus();
                  }
                },
                enabled: onChanged != null,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 32,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _updateTime({int? hours, int? minutes, int? seconds}) {
    setState(() {
      _hours = (hours ?? _hours).clamp(0, 23);
      _minutes = (minutes ?? _minutes).clamp(0, 59);
      _seconds = (seconds ?? _seconds).clamp(0, 59);
      
      _hoursController.text = _hours.toString().padLeft(2, '0');
      _minutesController.text = _minutes.toString().padLeft(2, '0');
      _secondsController.text = _seconds.toString().padLeft(2, '0');
    });

    final duration = Duration(
      hours: _hours,
      minutes: _minutes,
      seconds: _seconds,
    );

    context.read<TimerProvider>().setTotalDuration(duration);
  }
}
