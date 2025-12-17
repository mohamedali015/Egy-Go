import 'package:dartz/dartz.dart';
import 'package:egy_go/features/create_trip/data/models/create_trip_response_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CreateTripFormRepo {
  Future<Either<String, CreateTripResponseModel>> createTrip({
    required String dateTime,
    required int duration,
    required String meetingPoint,
    required LatLng meetingPointLatLng,
    required String notes,
    required String governorateId,
  });
}
