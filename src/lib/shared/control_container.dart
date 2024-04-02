import 'package:flutter/material.dart';

class ControlContainer extends StatelessWidget {
  const ControlContainer({
    super.key,
    required this.children,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Row(
        children: children,
      ),
    );
  }
}
