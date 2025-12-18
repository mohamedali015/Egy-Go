import 'package:egy_go/features/places/data/models/places_response_model.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'place_category_state.dart';

class PlaceCategoryCubit extends Cubit<PlaceCategoryState> {
  PlaceCategoryCubit(this.repo) : super(PlaceCategoryInitial());

  static PlaceCategoryCubit get(context) => BlocProvider.of(context);

  final List<Place> placesByCategory = [];
  final PlacesRepo repo;

  Future<void> fetchPlacesByCategory(
      {required String category, required String governorate}) async {
    emit(PlacesCategoryLoading());
    final result = await repo.getPlacesByCategory(
        category: category, governorate: governorate);
    result.fold(
      (error) {
        emit(PlacesCategoryLoadError(error: error));
      },
      (placesList) {
        placesByCategory.clear();
        placesByCategory.addAll(placesList);
        emit(PlacesCategoryLoadSuccess(places: placesByCategory));
      },
    );
  }
}
