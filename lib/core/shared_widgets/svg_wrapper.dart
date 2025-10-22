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
    this.svgType = SvgType.normal,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final SvgType svgType;

  static ImageProvider provider(String path) => svg.Svg(path);

  @override
  Widget build(BuildContext context) {
    switch (svgType) {
      case SvgType.normal:
        return SvgPicture.asset(
          path,
          fit: fit,
          width: width,
          height: height,
        );
      case SvgType.provider:
        return Image(
          image: svg.Svg(path),
          fit: fit,
          width: width,
          height: height,
        );
    }
  }
}

enum SvgType { normal, provider }
