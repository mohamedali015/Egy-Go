import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';

abstract class SelectGuideState {}

class SelectGuideInitial extends SelectGuideState {}

class SelectGuideLoading extends SelectGuideState {}

class SelectGuideSuccess extends SelectGuideState {
  final TripGuidesResponseModel guidesData;

  SelectGuideSuccess(this.guidesData);
}

class SelectGuideFailure extends SelectGuideState {
  final String errorMessage;

  SelectGuideFailure(this.errorMessage);
}
