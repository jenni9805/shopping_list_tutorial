import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_shopping_list_tutorial/controllers/item_list_controller.dart';
import 'package:flutter_shopping_list_tutorial/models/item_model.dart';
import 'package:flutter_shopping_list_tutorial/repositories/custom_exception.dart';
import 'package:flutter_shopping_list_tutorial/ui/add_item_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentItem = ScopedProvider<Item>((_) => throw UnimplementedError());

class ItemList extends HookWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemListState = useProvider(itemListControllerProvider);
    final filterItemList =useProvider(filteredItemListProvider);
    return itemListState.when(
      data: (items) => items.isEmpty
          ? const Center(
              child: Text(
                'Tap + to add an item',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : ListView.builder(
              itemCount: filterItemList.length,
              itemBuilder: (_, index) {
                final item = filterItemList[index];
                return ProviderScope(
                  overrides: [currentItem.overrideWithValue(item)],
                  child: const _ItemTile()
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ItemListError(
        message:
        error is CustomException ? error.message! : 'Something went wrong!',
      ),
    );
  }
}


class _ItemTile extends HookWidget{
  const _ItemTile({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final item = useProvider(currentItem);
    return ListTile(
      key: ValueKey(item.id),
      title: Text(item.name),
      trailing: Checkbox(
        value: item.obtained,
        onChanged: (val) => context
            .read(itemListControllerProvider.notifier)
            .updateItem(updatedItem: item.copyWith(obtained: !item.obtained)),
      ),
      onTap: () => AddItemDialog.show(context, item),
      onLongPress: () =>
          context.read(itemListControllerProvider.notifier).deleteItem(itemId: item.id!),
    );
  }

}


class _ItemListError extends StatelessWidget {
  final String message;

  const _ItemListError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 20.0)),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => context
                .read(itemListControllerProvider.notifier)
                .retrieveItems(isRefreshing: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}