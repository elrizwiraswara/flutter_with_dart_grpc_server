import 'package:flutter/material.dart';

import 'generated/groceries.pb.dart';
import 'main.dart';

class AddEditItemDialog extends StatefulWidget {
  final Item? item;
  final List<Category> categories;

  const AddEditItemDialog({super.key, this.item, required this.categories});

  @override
  State<AddEditItemDialog> createState() => _AddEditItemDialogState();
}

class _AddEditItemDialogState extends State<AddEditItemDialog> {
  TextEditingController nameController = TextEditingController();
  Category? selectedCategory;

  void onTapButton() {
    if (widget.item == null) {
      if (selectedCategory != null) {
        client.createItem(nameController.text, selectedCategory!.id).then((_) {
          Navigator.pop(context, 'added');
        });
      }
    } else {
      if (selectedCategory != null) {
        client
            .editItem(
                widget.item!.id, nameController.text, selectedCategory!.id)
            .then((_) {
          Navigator.pop(context, 'edited');
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      selectedCategory = widget.categories.firstWhere(
        (e) => e.id == widget.item!.categoryId,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: DropdownButton(
              hint: const Text('Category'),
              isExpanded: true,
              value: selectedCategory,
              items: widget.categories
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onTapButton();
              },
              child: Text(widget.item == null ? 'Add' : 'Edit'),
            ),
          )
        ],
      ),
    );
  }
}
