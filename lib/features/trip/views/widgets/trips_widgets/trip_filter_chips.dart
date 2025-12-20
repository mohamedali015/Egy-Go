import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/manager/trips_cubit/trips_cubit.dart';
import 'package:flutter/material.dart';

class TripFilterChips extends StatelessWidget {
  const TripFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TripsCubit.get(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            context,
            label: 'All',
            isSelected: cubit.selectedFilter == 'all',
            onTap: () => cubit.filterTrips('all'),
          ),
          SizedBox(width: MyResponsive.width(value: 8)),
          _buildFilterChip(
            context,
            label: 'Ongoing',
            isSelected: cubit.selectedFilter == 'ongoing',
            onTap: () => cubit.filterTrips('ongoing'),
          ),
          SizedBox(width: MyResponsive.width(value: 8)),
          _buildFilterChip(
            context,
            label: 'Completed',
            isSelected: cubit.selectedFilter == 'completed',
            onTap: () => cubit.filterTrips('completed'),
          ),
          SizedBox(width: MyResponsive.width(value: 8)),
          _buildFilterChip(
            context,
            label: 'Cancelled',
            isSelected: cubit.selectedFilter == 'cancelled',
            onTap: () => cubit.filterTrips('cancelled'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 20)),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.medium14.copyWith(
            color: isSelected ? Colors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
