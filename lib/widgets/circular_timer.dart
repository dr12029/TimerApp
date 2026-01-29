import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircularTimerPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeWidth = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class CircularTimer extends StatelessWidget {
  final double progress;
  final String timeText;
  final Color? progressColor;

  const CircularTimer({
    super.key,
    required this.progress,
    required this.timeText,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveProgressColor = progressColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: CircularTimerPainter(
          progress: progress,
          progressColor: effectiveProgressColor,
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          strokeWidth: 14,
        ),
        child: Center(
          child: Text(
            timeText,
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 56,
              letterSpacing: -2,
            ),
          ),
        ),
      ),
    );
  }
}
