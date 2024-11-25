import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'item_card_store.g.dart';

@Singleton()
class ItemCardStore = ItemStoreBase with _$ItemCardStore;

abstract class ItemStoreBase with Store {
  @observable
  bool isOverlayVisible = false;

  @observable
  Map<String, dynamic>? selectedItem;

  @action
  void showOverlay(Map<String, dynamic> item) {
    selectedItem = item;
    isOverlayVisible = true;
  }

  @action
  void hideOverlay() {
    selectedItem = null;
    isOverlayVisible = false;
  }
}
