

import 'package:foodgarden/style/color.dart';
import 'package:flutter/material.dart';

class Component extends Container {
  Component(
      {Key? key,
      this.width,
      this.height,
      this.padding,
      this.margin,
      this.borderRadius,
      required this.child})
      : super(key: key);

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin ?? const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  color: primaryColor.withOpacity(0.3),
                  offset: const Offset(-2, 2)),
              BoxShadow(
                  blurRadius: 4,
                  color: primaryColor.withOpacity(0.3),
                  offset: const Offset(2, -2)),
            ]),
        child: child);
  }
}
