import 'package:dartz/dartz.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';

abstract class GuidesRepo {
  Future<Either<String, TripGuidesResponseModel>> getTripGuides(String tripId);
}
