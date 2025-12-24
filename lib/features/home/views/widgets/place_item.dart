import 'package:flutter/material.dart';

import '../../../../core/helper/my_navigator.dart';
import '../../../../core/helper/my_responsive.dart';
import '../../../../core/shared_widgets/cached_network_image_wrapper.dart';
import '../../../../core/shared_widgets/rating_bar_wrapper.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../places/data/models/places_response_model.dart';
import '../../../places/manager/places_cubit/places_cubit.dart';
import '../../../places/views/place_details_view.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    super.key,
    required this.place,
    required this.index,
    this.isFavorite = false,
    this.onTap,
  });

  final Place place;
  final int index;
  final bool? isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PlacesCubit.get(context).setSelectedPlace(place);
        MyNavigator.goTo(screen: PlaceDetailsView());
      },
      child: Container(
        height: MyResponsive.height(value: 170),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
          border: Border.all(
            color: AppColors.black.withValues(alpha: .2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: place.images!.isNotEmpty
                  ? CachedNetworkImageWrapper(
                      imagePath: place.images!.first,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppAssets.test,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(200),
                    ],
                    stops: const [0.2, 1.0],
                  ),
                ),
              ),
            ),
            if (isFavorite == true)
              Positioned(
                top: MyResponsive.height(value: 10),
                right: MyResponsive.width(value: 10),
                child: IconButton(
                  onPressed: onTap,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: AppColors.white.withValues(alpha: 0.4),
                  ),
                  icon: Icon(
                    Icons.close,
                    size: MyResponsive.fontSize(value: 25),
                  ),
                ),
              ),
            Positioned(
              left: MyResponsive.width(value: 14),
              right: MyResponsive.width(value: 14),
              bottom: MyResponsive.height(value: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          place.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bold18.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          RatingBarWrapper(
                            rating: 5,
                            starSize: 15,
                            spaceBetweenStars: 1,
                          ),
                          SizedBox(width: MyResponsive.width(value: 6)),
                          Text(
                            "(${place.rating ?? '0.0'})",
                            style: AppTextStyles.semiBold14.copyWith(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MyResponsive.height(value: 3)),
                  Text(
                    place.address ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.medium12.copyWith(
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
