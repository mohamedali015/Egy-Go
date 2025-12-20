import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/data/models/select_guide_response_model.dart';

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

class SelectGuideSelecting extends SelectGuideState {}

class SelectGuideSelected extends SelectGuideState {
  final SelectGuideResponseModel response;

  SelectGuideSelected(this.response);
}
