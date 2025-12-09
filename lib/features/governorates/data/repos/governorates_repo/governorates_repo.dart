import 'package:dartz/dartz.dart';

abstract class GovernoratesRepo {
  Future<List<Either<String, String>>> getGovernorates();
}
