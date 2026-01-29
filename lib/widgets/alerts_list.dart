import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../models/timer_alert.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final alerts = timerProvider.alerts;
    final isIdle = timerProvider.state == TimerState.idle;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alert Times',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (isIdle)
                  IconButton(
                    onPressed: () => _showAddAlertDialog(context),
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add Alert',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (alerts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No alerts set. Tap + to add alerts.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            else
              ...alerts.map((alert) => _buildAlertTile(context, alert, isIdle)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(BuildContext context, TimerAlert alert, bool isIdle) {
    final timerProvider = context.read<TimerProvider>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          alert.hasTriggered
              ? Icons.notifications_active
              : Icons.notifications_outlined,
          color: alert.hasTriggered ? theme.colorScheme.primary : null,
        ),
        title: Text(
          timerProvider.formatDuration(alert.time),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Alert at ${timerProvider.formatDuration(alert.time)}'),
        trailing: isIdle
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => timerProvider.removeAlert(alert.id),
              )
            : null,
        tileColor: alert.hasTriggered
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showAddAlertDialog(BuildContext context) {
    int hours = 0;
    int minutes = 5;
    int seconds = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Alert Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Set when the alert should trigger:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogTimeColumn(
                    context,
                    label: 'H',
                    value: hours,
                    onChanged: (value) => setState(() => hours = value),
                    max: 23,
                  ),
                  const Text(':', style: TextStyle(fontSize: 24)),
                  _buildDialogTimeColumn(
                    context,
                    label: 'M',
                    value: minutes,
                    onChanged: (value) => setState(() => minutes = value),
                    max: 59,
                  ),
                  const Text(':', style: TextStyle(fontSize: 24)),
                  _buildDialogTimeColumn(
                    context,
                    label: 'S',
                    value: seconds,
                    onChanged: (value) => setState(() => seconds = value),
                    max: 59,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final duration = Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                );
                context.read<TimerProvider>().addAlert(duration);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTimeColumn(
    BuildContext context, {
    required String label,
    required int value,
    required Function(int) onChanged,
    required int max,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.arrow_drop_up),
        ),
        Container(
          width: 60,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.arrow_drop_down),
        ),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
