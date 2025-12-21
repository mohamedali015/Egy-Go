import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit(this.repo) : super(CallInitial());

  static CallCubit get(context) => BlocProvider.of(context);
  final TripRepo repo;

  Future<void> initiateCall(String tripId, String guideId) async {
    emit(CallInitiating());
    final result = await repo.initiateCall(tripId, guideId);
    result.fold(
      (error) {
        emit(CallInitiationFailed(error));
      },
      (callResponse) {
        emit(CallInitiated(callResponse));
      },
    );
  }

  Future<void> endCall(
    String callId,
    String endReason,
    String summary,
    double? negotiatedPrice,
    bool agreedToTerms,
  ) async {
    emit(CallEnding());
    final result = await repo.endCall(
      callId,
      endReason,
      summary,
      negotiatedPrice,
      agreedToTerms,
    );
    result.fold(
      (error) {
        emit(CallEndFailed(error));
      },
      (endCallResponse) {
        emit(CallEnded(
          endCallResponse.trip!,
          endCallResponse.message ?? 'Call ended successfully',
        ));
      },
    );
  }
}
