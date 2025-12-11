import 'package:dartz/dartz.dart';
import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';

abstract class GovernoratesRepo {
  Future<Either<String, List<Governorate>>> getGovernorates();
}
