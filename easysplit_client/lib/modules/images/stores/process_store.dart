import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'process_store.g.dart';

@Singleton()
class ProcessStore = ProcessStoreBase with _$ProcessStore;

abstract class ProcessStoreBase with Store {
  @observable
  bool showAnimationBar = true;

  @observable
  bool showConnectionError = false;

  @observable
  bool noTextDetected = false;

  @observable
  bool loopingLastText = false;

  @action
  void setLoopingLastText(bool value) => loopingLastText = value;

  @action
  void setShowAnimationBar(bool value) => showAnimationBar = value;

  @action
  void setShowConnectionError(bool value) => showConnectionError = value;

  @action
  void setNoTextDetected(bool value) => noTextDetected = value;

  @action
  void reset() {
    showAnimationBar = true;
    showConnectionError = false;
    noTextDetected = false;
  }
}
