enum GuideState {
  notViewed,
  viewed,
}

abstract class GuideRepository {
  Stream<GuideState> get homeGuideState;
  Stream<GuideState> get splitGuideState;
  Stream<bool> get sampleHelpDismissed;

  Future<void> setHomeGuideViewed();
  Future<void> setSplitGuideViewed();
  Future<void> setSampleHelpDismissed();
}
