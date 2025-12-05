import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../helper/my_responsive.dart';
import '../utils/app_assets.dart';

class RatingBarWrapper extends StatelessWidget {
  const RatingBarWrapper({
    super.key,
    required this.rating,
    required this.starSize,
    required this.spaceBetweenStars,
    this.ignoreGestures = true,
  });

  final double rating;
  final double starSize;
  final double spaceBetweenStars;
  final bool? ignoreGestures;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemCount: 5,
      initialRating: rating,
      allowHalfRating: false,
      ignoreGestures: ignoreGestures!,
      itemSize: MyResponsive.fontSize(value: starSize),
      itemPadding: MyResponsive.paddingSymmetric(horizontal: spaceBetweenStars),
      ratingWidget: RatingWidget(
        full: SvgWrapper(
          path: AppAssets.filledStar,
          color: Colors.deepOrange,
        ),
        empty: SvgWrapper(
          path: AppAssets.star,
        ),
        half: SvgWrapper(
          path: AppAssets.star,
        ),
      ),
      onRatingUpdate: (value) {},
    );
  }
}
