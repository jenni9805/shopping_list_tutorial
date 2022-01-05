import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:flutter_shopping_list_tutorial/controllers/item_list_controller.dart';
import 'package:flutter_shopping_list_tutorial/models/item_model.dart';

class AddItemDialog extends HookWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        item: item,
      ),
    );
  }

  final Item item;

  const AddItemDialog({
    Key? key,
    required this.item,
  }) : super(key: key);

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(
      text: item.name,
    );
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Item name',
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    isUpdating ? Colors.orange : Theme.of(context).primaryColor,
              ),
              child: Text(isUpdating ? 'Update' : 'Add'),
              onPressed: () {
                isUpdating
                    ? context.read(itemListControllerProvider.notifier).updateItem(
                  updatedItem: item.copyWith(
                    name: textController.text.trim(),
                    obtained: item.obtained,
                  ),
                )
                    : context
                    .read(itemListControllerProvider.notifier)
                    .addItem(name: textController.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
