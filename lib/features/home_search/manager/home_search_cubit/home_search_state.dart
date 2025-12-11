import 'package:egy_go/features/places/data/models/places_response_model.dart';

abstract class HomeSearchState {}

class HomeSearchInitial extends HomeSearchState {}

class HomeSearchLoading extends HomeSearchState {}

class HomeSearchSuccess extends HomeSearchState {
  final List<Place> places;

  HomeSearchSuccess(this.places);
}

class HomeSearchFailure extends HomeSearchState {
  final String errorMessage;

  HomeSearchFailure(this.errorMessage);
}
