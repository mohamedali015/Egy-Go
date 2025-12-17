import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/create_trip/manager/create_trip_cubit/create_trip_cubit.dart';
import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTripFormWidget extends StatelessWidget {
  const CreateTripFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: CreateTripCubit.get(context).formKey,
      child: Column(
        children: [
          _buildDateField(context),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          _buildDurationField(context),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          _buildGovernoratesDropdown(context),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          _buildMeetingPointField(context),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          _buildNotesField(context),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Start Date & Time',
        labelStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .5)),
        hintStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .4)),
        filled: true,
        fillColor: AppColors.fill,
        // errorMaxLines: 2,
        contentPadding: MyResponsive.paddingSymmetric(
          horizontal: 13,
          vertical: 20,
        ),
        prefixIcon: Icon(
          Icons.calendar_month_outlined,
          color: AppColors.primary,
        ),
        border: _border(context, AppColors.grey),
        focusedErrorBorder: _border(context, AppColors.red),
        focusedBorder: _border(context, AppColors.primary),
        enabledBorder: _border(context, AppColors.grey),
        errorBorder: _border(context, AppColors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select date & time';
        }
        return null;
      },
      readOnly: true,
      controller: CreateTripCubit.get(context).dateTimeController,
      onTap: () => CreateTripCubit.get(context).pickDateTime(context),
    );
  }

  Widget _buildDurationField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Duration (Hours)',
        labelStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .5)),

        hintText: 'e.g. 4',
        hintStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .4)),

        filled: true,
        fillColor: AppColors.fill,
        // errorMaxLines: 2,
        contentPadding: MyResponsive.paddingSymmetric(
          horizontal: 13,
          vertical: 20,
        ),
        prefixIcon: Icon(
          Icons.access_time,
          color: AppColors.primary,
        ),
        border: _border(context, AppColors.grey),
        focusedErrorBorder: _border(context, AppColors.red),
        focusedBorder: _border(context, AppColors.primary),
        enabledBorder: _border(context, AppColors.grey),
        errorBorder: _border(context, AppColors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter duration';
        }
        return null;
      },
      controller: CreateTripCubit.get(context).durationController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildGovernoratesDropdown(BuildContext context) {
    final cubit = CreateTripCubit.get(context);
    final governoratesCubit = GovernoratesCubit.get(context);
    return DropdownButtonFormField<Governorate>(
      value: cubit.selectedGovernorate,
      decoration: InputDecoration(
        labelText: 'Select Governorates',
        labelStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .5)),

        filled: true,
        hintStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .4)),

        fillColor: AppColors.fill,
        // errorMaxLines: 2,
        contentPadding: MyResponsive.paddingSymmetric(
          horizontal: 13,
          vertical: 20,
        ),
        prefixIcon: Icon(
          Icons.home_outlined,
          color: AppColors.primary,
        ),
        border: _border(context, AppColors.grey),
        focusedErrorBorder: _border(context, AppColors.red),
        focusedBorder: _border(context, AppColors.primary),
        enabledBorder: _border(context, AppColors.grey),
        errorBorder: _border(context, AppColors.red),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select a governorate';
        }
        return null;
      },
      hint: Text(
        'Select Governorates',
        style: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .5)),
      ),
      items: governoratesCubit.governorates
          .map(
            (gov) => DropdownMenuItem<Governorate>(
              value: gov,
              child: Text(gov.name!),
            ),
          )
          .toList(),
      onChanged: (value) {
        cubit.selectedGovernorate = value;
      },
    );
  }

  Widget _buildMeetingPointField(BuildContext context) {
    return TextFormField(
      controller: CreateTripCubit.get(context).meetingPointController,
      decoration: InputDecoration(
        labelText: 'Meeting Point Address',
        labelStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .5)),
        hintText: 'e.g. Tahrir Square, Cairo',
        hintStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .4)),

        filled: true,
        fillColor: AppColors.fill,
        // errorMaxLines: 2,
        contentPadding: MyResponsive.paddingSymmetric(
          horizontal: 13,
          vertical: 20,
        ),
        prefixIcon: Icon(
          Icons.place_outlined,
          color: AppColors.primary,
        ),
        suffixIcon: IconButton(
          onPressed: () => openMapPicker(context),
          icon: Icon(
            Icons.map,
            color: AppColors.primary,
          ),
        ),
        border: _border(context, AppColors.grey),
        focusedErrorBorder: _border(context, AppColors.red),
        focusedBorder: _border(context, AppColors.primary),
        enabledBorder: _border(context, AppColors.grey),
        errorBorder: _border(context, AppColors.red),
      ),
      readOnly: true,
      onTap: () => openMapPicker(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter meeting point address';
        }
        return null;
      },
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextFormField(
      maxLines: 4,
      controller: CreateTripCubit.get(context).notesController,
      decoration: InputDecoration(
        hintText: 'Tell us more about your what you want to see or do...',
        hintStyle: AppTextStyles.bold13
            .copyWith(color: AppColors.grey.withValues(alpha: .4)),

        filled: true,
        fillColor: AppColors.fill,
        // errorMaxLines: 2,
        contentPadding: MyResponsive.paddingSymmetric(
          horizontal: 13,
          vertical: 20,
        ),
        // prefixIcon: Icon(
        //   Icons.notes,
        //   color: AppColors.primary,
        // ),
        border: _border(context, AppColors.grey),
        focusedErrorBorder: _border(context, AppColors.red),
        focusedBorder: _border(context, AppColors.primary),
        enabledBorder: _border(context, AppColors.grey),
        errorBorder: _border(context, AppColors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter what you want to do or want';
        }
        return null;
      },
    );
  }

  InputBorder _border(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(MyResponsive.radius(value: 10)),
      ),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  void openMapPicker(BuildContext context) async {
    final position = await CreateTripCubit.get(context).getCurrentLocation();

    LatLng selectedLocation = LatLng(position.latitude, position.longitude);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: selectedLocation,
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      onTap: (latLng) {
                        setState(() {
                          selectedLocation = latLng;
                        });
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: selectedLocation,
                        ),
                      },
                    ),
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 20),
                  ),
                  Padding(
                    padding: MyResponsive.paddingSymmetric(horizontal: 20),
                    child: CustomButton(
                      title: 'Confirm Location',
                      onPressed: () {
                        Navigator.pop(context, selectedLocation);
                      },
                    ),
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 20),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) async {
      if (value != null && value is LatLng) {
        await CreateTripCubit.get(context).getAddressFromLatLng(
          latitude: value.latitude,
          longitude: value.longitude,
        );
      }
    });
  }
}
