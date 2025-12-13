import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'governorates_state.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  GovernoratesCubit(this.repo) : super(GovernoratesInitial());

  static GovernoratesCubit get(context) => BlocProvider.of(context);
  final GovernoratesRepo repo;

  final List<Governorate> governorates = [];
  List<Governorate> filteredGovernorates = [];
  int selectedGovernorate = -1;

  Future<void> fetchGovernorates() async {
    emit(GovernoratesLoading());
    final result = await repo.getGovernorates();
    result.fold(
      (error) {
        emit(GovernoratesFailure(error));
      },
      (governoratesList) {
        governorates.clear();
        governorates.addAll(governoratesList);

        filteredGovernorates = List.from(governorates);

        emit(GovernoratesSuccess(governorates));
      },
    );
  }

  void searchGovernorates(String query) {
    if (query.isEmpty) {
      filteredGovernorates = List.from(governorates);
    } else {
      filteredGovernorates = governorates
          .where((governorate) =>
              governorate.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    emit(GovernoratesSuccess(filteredGovernorates));
  }
}
