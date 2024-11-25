import 'package:easysplit_flutter/common/repositories/interfaces/guide_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: GuideRepository)
class LocalGuideRepository extends GuideRepository {
  final _homeGuideStatusStreamController =
      BehaviorSubject<GuideState>.seeded(GuideState.notViewed);
  final _splitGuideStatusStreamController =
      BehaviorSubject<GuideState>.seeded(GuideState.notViewed);
  final _sampleHelpDismissedStreamController =
      BehaviorSubject<bool>.seeded(false);

  final _homeGuideKey = 'home_guide_key';
  final _splitGuideKey = 'split_guide_key';
  final _sampleHelpKey = 'sample_help_dismissed_key';

  LocalGuideRepository() {
    _loadGuideStatuses();
  }

  Future<void> _loadGuideStatuses() async {
    final prefs = await SharedPreferences.getInstance();

    final homeGuideViewed = prefs.getBool(_homeGuideKey) ?? false;
    _homeGuideStatusStreamController
        .add(homeGuideViewed ? GuideState.viewed : GuideState.notViewed);

    final splitGuideViewed = prefs.getBool(_splitGuideKey) ?? false;
    _splitGuideStatusStreamController
        .add(splitGuideViewed ? GuideState.viewed : GuideState.notViewed);

    final sampleHelpDismissed = prefs.getBool(_sampleHelpKey) ?? false;
    _sampleHelpDismissedStreamController.add(sampleHelpDismissed);
  }

  @override
  Stream<GuideState> get homeGuideState =>
      _homeGuideStatusStreamController.asBroadcastStream();

  @override
  Stream<GuideState> get splitGuideState =>
      _splitGuideStatusStreamController.asBroadcastStream();

  @override
  Stream<bool> get sampleHelpDismissed =>
      _sampleHelpDismissedStreamController.asBroadcastStream();

  @override
  Future<void> setHomeGuideViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_homeGuideKey, true);
    _homeGuideStatusStreamController.add(GuideState.viewed);
  }

  @override
  Future<void> setSplitGuideViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_splitGuideKey, true);
    _splitGuideStatusStreamController.add(GuideState.viewed);
  }

  @override
  Future<void> setSampleHelpDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sampleHelpKey, true);
    _sampleHelpDismissedStreamController.add(true);
  }
}
