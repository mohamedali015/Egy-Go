import 'package:egy_go/features/places/data/models/places_response_model.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoadSuccess extends PlacesState {
  final List<Place> places;

  PlacesLoadSuccess({required this.places});
}

class PlacesLoadError extends PlacesState {
  final String error;

  PlacesLoadError({required this.error});
}

