import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// The script "Halo" logo, in the right ink for the current theme.
class HaloMark extends StatelessWidget {
  const HaloMark({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? 'assets/brand/halo-dark.png' : 'assets/brand/halo-light.png',
      height: height,
      semanticLabel: 'Halo',
      // Missing asset (e.g. in some tests) shouldn't break the layout.
      errorBuilder: (_, _, _) => SizedBox(height: height),
    );
  }
}

/// Loading indicator drawn from the logo: a thin ring with a dot in orbit.
/// Holds still when the system asks for reduced motion.
class HaloSpinner extends StatefulWidget {
  const HaloSpinner({super.key, this.size = 36});

  final double size;

  @override
  State<HaloSpinner> createState() => _HaloSpinnerState();
}

class _HaloSpinnerState extends State<HaloSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = HaloColors.of(context).ring;
    return Semantics(
      label: 'Yükleniyor',
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _RingPainter(color: color, turn: _controller.value),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.color, required this.turn});

  final Color color;
  final double turn;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 3;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = color.withValues(alpha: 0.55),
    );
    // Start at the logo's 3 o'clock dot and orbit from there.
    final angle = turn * 2 * math.pi;
    final dot = center + Offset(math.cos(angle), math.sin(angle)) * radius;
    canvas.drawCircle(dot, 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.turn != turn || old.color != color;
}

/// Centered spinner for full-area loading states.
class HaloLoading extends StatelessWidget {
  const HaloLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: HaloSpinner());
}

/// Soft golden light behind [child], like the halo on the magazine's banner.
/// The light fades out fully inside its own box, so it never shows an edge.
class HaloGlow extends StatelessWidget {
  const HaloGlow({super.key, required this.child, this.spread = 1.25});

  final Widget child;

  /// How far the light reaches, relative to the child's size.
  final double spread;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GlowPainter(color: HaloColors.of(context).glow, spread: spread),
      child: child,
    );
  }
}

class _GlowPainter extends CustomPainter {
  _GlowPainter({required this.color, required this.spread});

  final Color color;
  final double spread;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.longestSide / 2 * spread;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0),
          ],
          stops: const [0, 0.5, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlowPainter old) =>
      old.color != color || old.spread != spread;
}

/// The logo's ring (dot at three o'clock) drawn around [child].
class HaloRing extends StatelessWidget {
  const HaloRing({super.key, required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RingPainter(
                color: HaloColors.of(context).ring,
                turn: 0,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
