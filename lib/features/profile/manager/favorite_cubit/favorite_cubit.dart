import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/user/manager/user_cubit/user_cubit.dart';
import '../../../places/data/models/places_response_model.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  static FavoriteCubit get(context) => BlocProvider.of(context);

  List<Place> favoritePlace = [];

  void init(List<Place> places) {
    favoritePlace = List.from(places);
    emit(FavoriteLoaded());
  }

  void removeFromFavorite({
    required Place place,
    required UserCubit userCubit,
  }) {
    favoritePlace.remove(place);
    userCubit.favoritePlaces.remove(place);

    emit(FavoriteUpdated());
  }
}
