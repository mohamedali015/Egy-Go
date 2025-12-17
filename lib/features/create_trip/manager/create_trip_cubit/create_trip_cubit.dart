import 'package:egy_go/core/helper/custom_logger.dart';
import 'package:egy_go/features/create_trip/data/repos/create_trip_form_repo/create_trip_form_repo.dart';
import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit(this.repo) : super(CreateTripInitial());

  static CreateTripCubit get(BuildContext context) =>
      BlocProvider.of<CreateTripCubit>(context);

  CreateTripFormRepo repo;

  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController meetingPointController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Governorate? selectedGovernorate;
  LatLng? selectedLocation;

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    int number = int.parse(durationController.text);
    number = number * 60;

    emit(CreateTripLoading());
    var result = await repo.createTrip(
      dateTime: dateTimeController.text,
      duration: number,
      meetingPoint: meetingPointController.text,
      notes: notesController.text,
      governorateId: selectedGovernorate!.sId!,
      meetingPointLatLng: selectedLocation!,
    );

    result.fold(
      (error) => emit(CreateTripFailure(error)),
      (response) => emit(CreateTripSuccess(response)),
    );
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final DateTime dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    dateTimeController.text =
        "${dateTime.day}/${dateTime.month}/${dateTime.year} "
        "${time.format(context)}";
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return 'Unknown location';

      final place = placemarks.first;

      selectedLocation = LatLng(latitude, longitude);

      meetingPointController.text = '${place.street}, '
          '${place.subLocality}, '
          '${place.locality}, '
          '${place.administrativeArea}, '
          '${place.country}';

      CustomLogger.bgWhite(meetingPointController.text);
      CustomLogger.bgWhite(
          'Latitude: ${selectedLocation!.latitude}, Longitude: ${selectedLocation!.longitude}');
      return '${place.street}, '
          '${place.subLocality}, '
          '${place.locality}, '
          '${place.administrativeArea}, '
          '${place.country}';
    } catch (e) {
      return 'Failed to get address';
    }
  }
}
