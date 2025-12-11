import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'governorates_state.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  GovernoratesCubit(this.repo) : super(GovernoratesInitial());

  static GovernoratesCubit get(context) => BlocProvider.of(context);
  final GovernoratesRepo repo;

  final List<Governorate> governorates = [];

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
        emit(GovernoratesSuccess(governorates));
      },
    );
  }
}
