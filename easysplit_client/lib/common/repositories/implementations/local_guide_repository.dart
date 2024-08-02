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

  final _homeGuideKey = 'home_guide_key';
  final _splitGuideKey = 'split_guide_key';

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
  }

  @override
  Stream<GuideState> get homeGuideState =>
      _homeGuideStatusStreamController.asBroadcastStream();

  @override
  Stream<GuideState> get splitGuideState =>
      _splitGuideStatusStreamController.asBroadcastStream();

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
}
