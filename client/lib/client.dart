import 'package:grpc/grpc.dart';

import 'generated/groceries.pbgrpc.dart';

class Client {
  ClientChannel? channel;
  GroceriesServiceClient? stub;

  Future<void> connect() async {
    channel = ClientChannel(
      '192.168.43.237',
      port: 50000,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    stub = GroceriesServiceClient(
      channel!,
      options: CallOptions(
        timeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<void> shutdown() async {
    await channel!.shutdown();
  }

  Future<List<Item>> getAllItems() async {
    final response = await stub!.getAllItems(Empty());
    return response.items;
  }

  Future<List<Category>> getAllCategories() async {
    final response = await stub!.getAllCategories(Empty());
    return response.categories;
  }

  Future<Category> getCategoryById(int id) async {
    var category = Category()..id = id;
    category = await stub!.getCategory(category);
    return category;
  }

  Future<Item> getItemById(int id) async {
    var item = Item()..id = id;
    item = await stub!.getItem(item);
    return item;
  }

  Future<bool> deleteItemById(int id) async {
    var item = Item()..id = id;
    await stub!.deleteItem(item);
    return true;
  }

  Future<bool> deleteCategoryById(int id) async {
    var category = Category()..id = id;
    await stub!.deleteCategory(category);
    return true;
  }

  Future<Item> createItem(String name, int categoryId) async {
    var item = Item()
      ..name = name
      ..id = (await getAllItems()).length + 1
      ..categoryId = categoryId;
    final response = await stub!.createItem(item);
    return response;
  }

  Future<Item> editItem(int id, String name, int categoryId) async {
    var item = Item()
      ..name = name
      ..id = id
      ..categoryId = categoryId;
    final response = await stub!.editItem(item);
    return response;
  }

  Future<Category> createCategory(String name) async {
    var category = Category()
      ..name = name
      ..id = (await getAllCategories()).length + 1;
    final response = await stub!.createCategory(category);
    return response;
  }
}
