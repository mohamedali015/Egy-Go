import 'package:egy_go/features/places/data/models/places_response_model.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit(this.repo) : super(PlacesInitial());

  static PlacesCubit get(context) => BlocProvider.of(context);
  final PlacesRepo repo;

  final List<Place> places = [];
  Place? selectedPlace;

  void setSelectedPlace(Place place) {
    selectedPlace = place;
  }

  Future<void> fetchPlaces() async {
    emit(PlacesLoading());
    final result = await repo.getPlaces();
    result.fold(
      (error) {
        emit(PlacesLoadError(error: error));
      },
      (placesList) {
        places.clear();
        places.addAll(placesList);
        emit(PlacesLoadSuccess(places: places));
      },
    );
  }
}
