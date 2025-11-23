import 'package:flutter/material.dart';

class HoverableContainer extends StatefulWidget {
  final Widget child;
  final Color color;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const HoverableContainer({
    super.key,
    required this.child,
    required this.color,
    required this.onTap,
    this.borderRadius,
    this.padding,
  });

  @override
  State<HoverableContainer> createState() => _HoverableContainerState();
}

class _HoverableContainerState extends State<HoverableContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withOpacity(0.1)
                : Theme.of(context).cardColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.color
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: _isHovered ? 2 : 1,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}