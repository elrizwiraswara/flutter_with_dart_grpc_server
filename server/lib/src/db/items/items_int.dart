import '../../../dart_grpc_server.dart';

abstract class IItemsServices {
  factory IItemsServices() => ItemsServices();
  Item? getItemByName(String name) {
    return null;
  }

  Item? getItemById(int id) {
    return null;
  }

  Item? createItem(Item item) {
    return null;
  }

  Item? editItem(Item item) {
    return null;
  }

  Empty? deleteItem(Item item) {
    return null;
  }

  List<Item>? getItems() {
    return null;
  }

  List<Item>? getItemsByCategory(int categoryId) {
    return null;
  }
}

final itemsServices = IItemsServices();
