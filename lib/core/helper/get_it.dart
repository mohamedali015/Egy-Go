import 'package:egy_go/core/network/api_helper.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<ApiHelper>(ApiHelper());
}
