import 'package:flutter/material.dart';

/// Animated counter widget that counts from 0 to target value
class AnimatedCount extends StatefulWidget {
  final double value;
  final Duration duration;
  final Curve curve;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final int? fractionDigits;
  final bool useCurrency;

  const AnimatedCount({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeOut,
    this.style,
    this.prefix,
    this.suffix,
    this.fractionDigits,
    this.useCurrency = false,
  });

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.useCurrency) {
      return '\$${value.toStringAsFixed(widget.fractionDigits ?? 2)}';
    }
    if (widget.fractionDigits != null) {
      return value.toStringAsFixed(widget.fractionDigits!);
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayValue = _formatValue(_animation.value);
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.prefix ?? ''}$displayValue${widget.suffix ?? ''}',
            style: widget.style,
          ),
        );
      },
    );
  }
}
