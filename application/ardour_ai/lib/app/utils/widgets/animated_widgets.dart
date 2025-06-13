import 'package:flutter/widgets.dart';

class AnimatedCrossFadeUp extends StatefulWidget {
  const AnimatedCrossFadeUp({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.preventAutoPlay = false,
  });

  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final bool preventAutoPlay;

  @override
  State<AnimatedCrossFadeUp> createState() => AnimatedCrossFadeUpState();
}

class AnimatedCrossFadeUpState extends State<AnimatedCrossFadeUp>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> opacity;
  late Animation<double> position;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 1),
    );

    opacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    position = Tween(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (!widget.preventAutoPlay) {
      if (widget.delay != null) {
        Future.delayed(widget.delay!, () {
          if (_controller != null) _controller.forward();
        });
      } else {
        _controller.forward();
      }
    }
  }

  void playAnimation() => _controller.forward();
  void reverseAnimation() => _controller.forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder:
          (context, oldWidget) => Opacity(
            opacity: opacity.value,
            child: Transform.translate(
              offset: Offset(0, position.value),
              child: widget.child,
            ),
          ),
    );
  }
}
