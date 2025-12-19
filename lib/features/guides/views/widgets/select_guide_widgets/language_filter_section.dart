import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:flutter/material.dart';

class LanguageFilterSection extends StatelessWidget {
  const LanguageFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = SelectGuideCubit.get(context);
    final languages = cubit.getAvailableLanguages();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Language',
          style: AppTextStyles.bold16,
        ),
        SizedBox(height: MyResponsive.height(value: 12)),
        Wrap(
          spacing: MyResponsive.width(value: 8),
          runSpacing: MyResponsive.height(value: 8),
          children: [
            _FilterChip(
              label: 'All',
              isSelected: cubit.selectedLanguage == null,
              onTap: () => cubit.filterByLanguage(null),
            ),
            ...languages.map((language) => _FilterChip(
                  label: language,
                  isSelected: cubit.selectedLanguage == language,
                  onTap: () => cubit.filterByLanguage(language),
                )),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.black.withValues(alpha: .2),
          ),
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 20)),
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
