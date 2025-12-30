import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/views/select_guide_screen.dart';
import 'package:flutter/material.dart';

class GuideFilterScreen extends StatelessWidget {
  const GuideFilterScreen({super.key, required this.tripId});

  final String tripId;

  static const String routeName = "guideFilter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Guide Type',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose the type of guide you need:',
              style: AppTextStyles.semiBold18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Local Guide Button - Get all guides
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectGuideScreen(
                      tripId: tripId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Local Guide',
                    style: AppTextStyles.semiBold18,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All available guides',
                    style: AppTextStyles.regular14,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Archaeological Sites Guide Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectGuideScreen(
                      tripId: tripId,
                      isLicensed: true,
                      canEnterArchaeologicalSites: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Archaeological Sites Guide',
                    style: AppTextStyles.semiBold18,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Can enter archaeological sites',
                    style: AppTextStyles.regular14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
