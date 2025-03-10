import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/home/widgets/home_button.dart';
import 'dart:ui' as ui;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: GlowingBorderContainer(
          child: Container(
            height: screenSize.height / 3,
            width: screenSize.width / 3,
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height / 9,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeButton(
                  icon: Icons.auto_awesome,
                  label: 'подборки',
                  onTap: () {
                    print('ты гей');
                  },
                ),
                HomeButton(
                  icon: Icons.group_work,
                  label: 'создать',
                  onTap: () {
                    print('я гей');
                    context.go(mainRoute + createRoute);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlowingBorderContainer extends StatefulWidget {
  const GlowingBorderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GlowingBorderContainer> createState() => _GlowingBorderContainerState();
}

class _GlowingBorderContainerState extends State<GlowingBorderContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          return CustomPaint(
            painter: GlowingBorderPainter(value: _controller.value),
            child: child,
          );
        },
      );
}

class GlowingBorderPainter extends CustomPainter {
  const GlowingBorderPainter({
    required this.value,
  });

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10)
      ..shader = ui.Gradient.sweep(
        Offset(size.width, size.height) / 2,
        Colors.primaries,
        List.generate(
          Colors.primaries.length,
          (int index) => index / (Colors.primaries.length - 1),
        ),
        TileMode.mirror,
        value * 2 * pi,
        (value + 1) * 2 * pi,
      );

    final RRect rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rect, glowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      (oldDelegate as GlowingBorderPainter).value != value;
}
