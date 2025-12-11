import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';

abstract class GovernoratesState {}

class GovernoratesInitial extends GovernoratesState {}

class GovernoratesLoading extends GovernoratesState {}

class GovernoratesSuccess extends GovernoratesState {
  final List<Governorate> governorates;

  GovernoratesSuccess(this.governorates);
}

class GovernoratesFailure extends GovernoratesState {
  final String errorMessage;

  GovernoratesFailure(this.errorMessage);
}
