import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedRectangle extends StatefulWidget {
  final double? height;
  final double? width;

  const AnimatedRectangle({super.key, this.height, this.width});

  @override
  State<AnimatedRectangle> createState() => _AnimatedRectangleState();
}

class _AnimatedRectangleState extends State<AnimatedRectangle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bottomAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _leftAnimation;
  late Animation<double> _rightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _bottomAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _leftAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _rightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _topAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _replayAnimation();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replayAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: RectanglePainter(
                    _bottomAnimation.value,
                    _topAnimation.value,
                    _leftAnimation.value,
                    _rightAnimation.value,
                  ),
                  size: Size(widget.height ?? 22, widget.width ?? 40),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final double bottomAnimationValue;
  final double topAnimationValue;
  final double leftAnimationValue;
  final double rightAnimationValue;

  RectanglePainter(
    this.bottomAnimationValue,
    this.topAnimationValue,
    this.leftAnimationValue,
    this.rightAnimationValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final double rectWidth = size.width;
    final double rectHeight = size.height;

    final Paint linePaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.5;

    final double bottomSwapValue = bottomAnimationValue * rectWidth;
    final double bottomLeft = bottomSwapValue;
    final double bottomRight = rectWidth - bottomLeft;

    final double topSwapValue = topAnimationValue * rectWidth;
    final double topLeft = rectWidth - topSwapValue;
    final double topRight = rectWidth - topLeft;

    canvas.drawLine(Offset(bottomLeft, rectHeight), Offset(bottomRight, rectHeight), linePaint);
    canvas.drawLine(Offset(topLeft, 0), Offset(topRight, 0), linePaint);
    canvas.drawLine(Offset(topLeft, 0), Offset(bottomLeft, rectHeight), linePaint);
    canvas.drawLine(Offset(topRight, 0), Offset(bottomRight, rectHeight), linePaint);
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) =>
      bottomAnimationValue != oldDelegate.bottomAnimationValue ||
      topAnimationValue != oldDelegate.topAnimationValue ||
      leftAnimationValue != oldDelegate.leftAnimationValue ||
      rightAnimationValue != oldDelegate.rightAnimationValue;
}
