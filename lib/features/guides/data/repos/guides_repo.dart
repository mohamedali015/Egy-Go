import 'package:dartz/dartz.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/data/models/select_guide_response_model.dart';

abstract class GuidesRepo {
  Future<Either<String, TripGuidesResponseModel>> getTripGuides(String tripId);

  Future<Either<String, SelectGuideResponseModel>> selectGuide(
      String tripId, String guideId);
}
