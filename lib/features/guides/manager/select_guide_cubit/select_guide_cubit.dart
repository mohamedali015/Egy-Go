import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'select_guide_state.dart';

class SelectGuideCubit extends Cubit<SelectGuideState> {
  SelectGuideCubit(this.repo) : super(SelectGuideInitial());

  static SelectGuideCubit get(context) => BlocProvider.of(context);
  final GuidesRepo repo;

  List<Guide> allGuides = [];
  List<Guide> filteredGuides = [];
  String? selectedLanguage;
  TripInfo? tripInfo;

  Future<void> fetchTripGuides(String tripId) async {
    emit(SelectGuideLoading());
    final result = await repo.getTripGuides(tripId);
    result.fold(
      (error) {
        emit(SelectGuideFailure(error));
      },
      (guidesData) {
        allGuides.clear();
        if (guidesData.guides != null) {
          allGuides.addAll(guidesData.guides!);
        }
        filteredGuides = List.from(allGuides);
        tripInfo = guidesData.trip;
        emit(SelectGuideSuccess(guidesData));
      },
    );
  }

  void filterByLanguage(String? language) {
    selectedLanguage = language;
    if (language == null || language.isEmpty) {
      filteredGuides = List.from(allGuides);
    } else {
      filteredGuides = allGuides
          .where((guide) =>
              guide.languages != null &&
              guide.languages!
                  .any((lang) => lang.toLowerCase() == language.toLowerCase()))
          .toList();
    }
    emit(SelectGuideSuccess(TripGuidesResponseModel(
      success: true,
      guides: filteredGuides,
      trip: tripInfo,
    )));
  }

  List<String> getAvailableLanguages() {
    Set<String> languages = {};
    for (var guide in allGuides) {
      if (guide.languages != null) {
        // Filter out any null or empty strings - FIX: Handle null values properly
        languages.addAll(
          guide.languages!
              .where((lang) => lang != null && lang.isNotEmpty)
              .map((lang) => lang.toString()),
        );
      }
    }
    return languages.toList()..sort();
  }

  Future<void> selectGuide(String tripId, String guideId) async {
    emit(SelectGuideSelecting());
    final result = await repo.selectGuide(tripId, guideId);
    result.fold(
      (error) {
        emit(SelectGuideFailure(error));
      },
      (response) {
        emit(SelectGuideSelected(response));
      },
    );
  }
}
