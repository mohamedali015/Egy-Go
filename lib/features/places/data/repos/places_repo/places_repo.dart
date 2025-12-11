import 'package:dartz/dartz.dart';
import 'package:egy_go/features/places/data/models/places_response_model.dart';

abstract class PlacesRepo {
  Future<Either<String, List<Place>>> getPlaces();
}
