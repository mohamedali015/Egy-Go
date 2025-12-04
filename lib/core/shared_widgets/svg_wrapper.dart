import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

class SvgWrapper extends StatelessWidget {
  const SvgWrapper({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.scaleDown,
    this.color,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  static ImageProvider provider(String path) => svg.Svg(path);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
