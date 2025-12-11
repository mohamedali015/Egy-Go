import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/home_search_repo.dart';
import 'home_search_state.dart';

class HomeSearchCubit extends Cubit<HomeSearchState> {
  HomeSearchCubit(this.homeSearchRepo) : super(HomeSearchInitial());

  static HomeSearchCubit get(context) => BlocProvider.of(context);

  HomeSearchRepo homeSearchRepo;

  final FocusNode focusNode = FocusNode();
  Timer? _debounce;

  void focusOnTextField(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> homeSearchPlaces(String value) async {
    if (value.trim().isEmpty) {
      _debounce?.cancel();
      emit(HomeSearchSuccess([]));
      return;
    }

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      emit(HomeSearchLoading());

      final result = await homeSearchRepo.fetchHomeSearchPlaces(search: value);

      result.fold(
        (message) => emit(HomeSearchFailure(message)),
        (places) => emit(HomeSearchSuccess(places)),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
