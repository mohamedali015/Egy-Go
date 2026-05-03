import 'package:egy_go/core/user/data/models/user_model.dart';
import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/home/views/app_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_key.dart';
import '../../../../core/helper/my_navigator.dart';
import '../../../../features/places/data/models/places_response_model.dart';
import '../../data/repo/user_repo.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepo) : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  /// Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Data
  UserModel userModel = UserModel();
  List<Place> favoritePlaces = [];

  final UserRepo userRepo;

  /// get user data
  Future<bool> getUserData() async {
    emit(UserLoading());
    var response = await userRepo.getUserData();
    return response.fold(
      (error) {
        emit(UserGetError(error: error));
        return false;
      },
      (user) {
        userModel = user;

        nameController.text = userModel.name ?? '';
        phoneController.text = userModel.phone ?? '';

        emit(UserGetSuccess(userModel: user));
        return true;
      },
    );
  }

  /// update user data locally and emit state
  Future<void> updateUserData() async {
    if (formKey.currentState!.validate()) {
      emit(UserUpdateLoading());

      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 2));

      // Update the userModel with new values
      userModel.name = nameController.text;
      userModel.phone = phoneController.text;

      MyNavigator.goTo(
          screen: AppHomeView(
            initialIndex: 2,
          ),
          isReplace: true);

      // Emit success state so all listeners can react
      emit(UserUpdateSuccess(message: 'Profile updated successfully'));

      // Optionally: Make API call to update on server
      // var result = await userRepo.updateUserData(
      //   name: nameController.text,
      //   phone: phoneController.text,
      // );
      // result.fold(
      //   (String error) {
      //     emit(UserUpdateError(error: error));
      //   },
      //   (message) async {
      //     await getUserData();
      //     emit(UserUpdateSuccess(message: message));
      //   },
      // );
    } else {
      emit(UserUpdateError(error: 'Please fill all fields'));
    }
  }

  /// logout
  Future<void> logout() async {
    await CacheHelper.removeData(key: CacheKeys.accessToken);
    await CacheHelper.removeData(key: CacheKeys.refreshToken);
    MyNavigator.goTo(screen: GetStartedView(), isReplace: true);
  }

  Position? userPosition;

  void saveUserLocation(Position position) {
    userPosition = position;
  }

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. هل اللوكيشن شغال أصلاً؟
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 2. هل فيه permission؟
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied, please enable it from profile',
      );
    }

    // 3. هات اللوكيشن
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
