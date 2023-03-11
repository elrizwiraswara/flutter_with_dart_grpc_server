import 'package:flutter/material.dart';

import 'add_item_dialog.dart';
import 'client.dart';
import 'generated/groceries.pb.dart';

Client client = Client();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groceries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Groceries App Using gRPC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item>? items;
  List<Category>? categories;

  void getAllItem() async {
    items = await client.getAllItems();
    setState(() {});
  }

  void getAllCategory() async {
    categories = await client.getAllCategories();
    setState(() {});
  }

  void onTapAddButton() async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AddEditItemDialog(
            categories: categories ?? [],
          ),
        );
      },
    );

    if (res == 'added') {
      getAllItem();
      showSnackbar('Item added');
    } else {
      showSnackbar('Item failed to add');
    }
  }

  void onTapEditButton(Item item) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AddEditItemDialog(
            item: item,
            categories: categories ?? [],
          ),
        );
      },
    );

    if (res == 'edited') {
      getAllItem();
      showSnackbar('Item edited');
    } else {
      showSnackbar('Item failed to edit');
    }
  }

  void deleteItem(int id, String name) async {
    final res = await client.deleteItemById(id);

    if (res) {
      getAllItem();
      showSnackbar('Item $name deleted');
    } else {
      showSnackbar('Item $name failed to delete');
    }
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await client.connect();
      getAllItem();
      getAllCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: items == null
          ? const Center(child: CircularProgressIndicator())
          : items!.isEmpty
              ? const Center(
                  child: Text(
                    '(Empty)',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                )
              : body(),
      floatingActionButton: FloatingActionButton(
        onPressed: onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ...List.generate(items!.length, (i) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items![i].name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    categories
                            ?.firstWhere((e) => e.id == items![i].categoryId)
                            .name ??
                        '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Text(items![i].id.toString()),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      onTapEditButton(items![i]);
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      deleteItem(items![i].id, items![i].name);
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
