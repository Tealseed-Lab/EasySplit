enum GuideState {
  notViewed,
  viewed,
}

abstract class GuideRepository {
  Stream<GuideState> get homeGuideState;
  Stream<GuideState> get splitGuideState;

  Future<void> setHomeGuideViewed();
  Future<void> setSplitGuideViewed();
}
