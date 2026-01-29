import 'package:flutter/material.dart';
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
                  onIncrement: isIdle ? () => _updateTime(hours: _hours + 1) : null,
                  onDecrement: isIdle && _hours > 0 ? () => _updateTime(hours: _hours - 1) : null,
                ),
                Text(':', style: theme.textTheme.headlineMedium),
                _buildTimeColumn(
                  label: 'Minutes',
                  value: _minutes,
                  onIncrement: isIdle && _minutes < 59 ? () => _updateTime(minutes: _minutes + 1) : null,
                  onDecrement: isIdle && _minutes > 0 ? () => _updateTime(minutes: _minutes - 1) : null,
                ),
                Text(':', style: theme.textTheme.headlineMedium),
                _buildTimeColumn(
                  label: 'Seconds',
                  value: _seconds,
                  onIncrement: isIdle && _seconds < 59 ? () => _updateTime(seconds: _seconds + 1) : null,
                  onDecrement: isIdle && _seconds > 0 ? () => _updateTime(seconds: _seconds - 1) : null,
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
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.keyboard_arrow_up),
          iconSize: 32,
        ),
        Container(
          width: 70,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
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
      _hours = hours ?? _hours;
      _minutes = minutes ?? _minutes;
      _seconds = seconds ?? _seconds;
    });

    final duration = Duration(
      hours: _hours,
      minutes: _minutes,
      seconds: _seconds,
    );

    context.read<TimerProvider>().setTotalDuration(duration);
  }
}
