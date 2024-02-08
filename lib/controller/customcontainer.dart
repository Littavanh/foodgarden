// ignore_for_file: overridden_fields, annotate_overrides



import 'package:foodgarden/style/color.dart';
import 'package:foodgarden/style/textstyle.dart';
import 'package:flutter/material.dart';

class CustomContainer extends Container {
  CustomContainer(
      {Key? key,
      this.padding,
      this.height,
      this.width,
      required this.child,
      this.margin,
      this.title,
      this.borderRadius,
      this.shadowColor,
      this.color,
      this.errorMsg})
      : super(key: key);
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final Widget child;
  final EdgeInsets? margin;
  final Widget? title;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final Color? color;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.only(left: 10),
          child: title ?? const Center(),
        ),
        Container(
          padding: padding ?? const EdgeInsets.all(0),
          margin: margin ?? const EdgeInsets.only(left: 10, right: 10),
          width: width,
          height: height,
          child: child,
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).backgroundColor,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    color: shadowColor ?? primaryColor.withOpacity(0.3),
                    offset: const Offset(-2, 2)),
                BoxShadow(
                    blurRadius: 4,
                    color: shadowColor ?? primaryColor.withOpacity(0.3),
                    offset: const Offset(2, -2)),
              ]),
        ),
        Padding(
          padding: padding ?? const EdgeInsets.only(left: 10, bottom: 0),
          child: Text(errorMsg ?? '', style: errorText),
        )
      ],
    );
  }
}
