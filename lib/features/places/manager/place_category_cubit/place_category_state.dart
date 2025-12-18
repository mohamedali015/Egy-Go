import '../../data/models/places_response_model.dart';

abstract class PlaceCategoryState {}

class PlaceCategoryInitial extends PlaceCategoryState {}

class PlacesCategoryLoading extends PlaceCategoryState {}

class PlacesCategoryLoadSuccess extends PlaceCategoryState {
  final List<Place> places;

  PlacesCategoryLoadSuccess({required this.places});
}

class PlacesCategoryLoadError extends PlaceCategoryState {
  final String error;

  PlacesCategoryLoadError({required this.error});
}
