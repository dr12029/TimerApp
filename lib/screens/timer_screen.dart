import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/circular_timer.dart';
import '../widgets/time_picker.dart';
import '../widgets/alerts_list.dart';
import 'settings_screen.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Timer',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: timerProvider.toggleTheme,
                            icon: Icon(
                              timerProvider.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                            ),
                            tooltip: 'Toggle Theme',
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings_outlined),
                            tooltip: 'Settings',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Circular timer with animation
                        Hero(
                          tag: 'timer_circle',
                          child: AnimatedScale(
                            scale: timerProvider.state == TimerState.running
                                ? 1.0
                                : 0.95,
                            duration: const Duration(milliseconds: 300),
                            child: CircularTimer(
                              progress: timerProvider.progress,
                              timeText: timerProvider.formatDuration(
                                timerProvider.remainingTime,
                              ),
                              progressColor:
                                  _getProgressColor(context, timerProvider),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Control buttons
                        _buildControlButtons(context, timerProvider),

                        const SizedBox(height: 24),

                        // Time picker (only when idle)
                        if (timerProvider.state == TimerState.idle) ...[
                          const TimePicker(),
                          const SizedBox(height: 16),
                        ],

                        // Alerts list
                        const AlertsList(),

                        const SizedBox(height: 80), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // White flash overlay for alerts
          if (timerProvider.isFlashing)
            AnimatedOpacity(
              opacity: timerProvider.isFlashing ? 0.9 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(
      BuildContext context, TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        if (timerProvider.state != TimerState.idle) ...[
          FloatingActionButton(
            onPressed: timerProvider.reset,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            heroTag: 'reset_button',
            child: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
        ],

        // Main play/pause button
        FloatingActionButton.large(
          onPressed: () {
            if (timerProvider.state == TimerState.idle ||
                timerProvider.state == TimerState.paused) {
              timerProvider.start();
            } else if (timerProvider.state == TimerState.running) {
              timerProvider.pause();
            } else if (timerProvider.state == TimerState.finished) {
              timerProvider.reset();
            }
          },
          heroTag: 'main_button',
          child: Icon(
            _getMainButtonIcon(timerProvider.state),
            size: 36,
          ),
        ),
      ],
    );
  }

  IconData _getMainButtonIcon(TimerState state) {
    switch (state) {
      case TimerState.idle:
      case TimerState.paused:
        return Icons.play_arrow;
      case TimerState.running:
        return Icons.pause;
      case TimerState.finished:
        return Icons.refresh;
    }
  }

  Color _getProgressColor(BuildContext context, TimerProvider timerProvider) {
    final theme = Theme.of(context);

    if (timerProvider.state == TimerState.finished) {
      return Colors.red;
    }

    // Change color based on remaining time
    final progress = timerProvider.progress;
    if (progress > 0.5) {
      return theme.colorScheme.primary;
    } else if (progress > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
