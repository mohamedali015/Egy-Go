import 'package:carousel_slider/carousel_slider.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:egy_go/features/places/manager/slider_cubit/slider_cubit.dart';
import 'package:flutter/material.dart';

class PlaceDetailsSlider extends StatelessWidget {
  const PlaceDetailsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = PlacesCubit.get(context);
    return CarouselSlider(
      options: CarouselOptions(
        height: MyResponsive.height(value: 400),
        autoPlay: true,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {
          SliderCubit.get(context).changeSliderIndex(index);
        },
      ),
      items: cubit.selectedPlace!.images?.map((imagePath) {
        return SliderWidget(
          imagePath: imagePath,
        );
      }).toList(),
    );
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageWrapper(
      imagePath: imagePath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
