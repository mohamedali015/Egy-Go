import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/app_colors.dart';

class ThirdSectionLocation extends StatelessWidget {
  const ThirdSectionLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = PlacesCubit.get(context);
    var place = cubit.selectedPlace!;
    List location = place.location!.coordinates!;
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.location,
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 4)),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.black.withValues(alpha: .4),
                size: MyResponsive.fontSize(value: 18),
              ),
              SizedBox(width: MyResponsive.width(value: 4)),
              Text(
                'Here is some information about the place',
                style: AppTextStyles.medium12.copyWith(
                  color: AppColors.black.withValues(alpha: .5),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Container(
            width: double.infinity,
            height: MyResponsive.height(value: 200),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MyResponsive.radius(value: 4)),
            ),
            child: StaticGoogleMapView(
              lat: location[0],
              lng: location[1],
            ),
          )
        ],
      ),
    );
  }
}

class StaticGoogleMapView extends StatelessWidget {
  final double lat;
  final double lng;

  const StaticGoogleMapView({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    final position = LatLng(lat, lng);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: position,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('place'),
          position: position,
        ),
      },
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (_) {},
    );
  }
}
