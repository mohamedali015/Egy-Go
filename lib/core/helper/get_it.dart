import 'package:egy_go/core/network/api_helper.dart';
import 'package:egy_go/core/user/data/repo/user_repo.dart';
import 'package:egy_go/core/user/data/repo/user_repo_impl.dart';
import 'package:egy_go/features/auth/data/repo/auth_repo.dart';
import 'package:egy_go/features/auth/data/repo/auth_repo_impl.dart';
import 'package:egy_go/features/create_trip/data/repos/create_trip_form_repo/create_trip_form_repo.dart';
import 'package:egy_go/features/create_trip/data/repos/create_trip_form_repo/create_trip_form_repo_impl.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo_impl.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo_impl.dart';
import 'package:egy_go/features/home_search/data/repo/home_search_repo.dart';
import 'package:egy_go/features/home_search/data/repo/home_search_repo_impl.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo_impl.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo_impl.dart';
import 'package:egy_go/features/trip/data/repos/chat_repo.dart';
import 'package:egy_go/features/trip/data/repos/chat_repo_impl.dart';
import 'package:egy_go/features/ai_chat/data/repos/ai_chat_repo.dart';
import 'package:egy_go/features/ai_chat/data/repos/ai_chat_repo_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<ApiHelper>(ApiHelper());

  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(apiHelper: getIt<ApiHelper>()),
  );

  getIt.registerSingleton<UserRepo>(
    UserRepoImpl(apiHelper: getIt<ApiHelper>()),
  );

  getIt.registerSingleton<GovernoratesRepo>(
      GovernoratesRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt.registerSingleton<PlacesRepo>(
      PlacesRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt.registerSingleton<HomeSearchRepo>(
      HomeSearchRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt.registerSingleton<CreateTripFormRepo>(
      CreateTripFormRepoImpl(getIt<ApiHelper>()));

  getIt.registerSingleton<GuidesRepo>(
      GuidesRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt
      .registerSingleton<TripRepo>(TripRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt
      .registerSingleton<ChatRepo>(ChatRepoImpl(apiHelper: getIt<ApiHelper>()));

  getIt.registerSingleton<AiChatRepo>(
      AiChatRepoImpl(apiHelper: getIt<ApiHelper>()));
}
