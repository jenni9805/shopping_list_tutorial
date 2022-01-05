import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_tutorial/controllers/auth_controller.dart';
import 'package:flutter_shopping_list_tutorial/controllers/item_list_controller.dart';
import 'package:flutter_shopping_list_tutorial/models/item_model.dart';
import 'package:flutter_shopping_list_tutorial/repositories/custom_exception.dart';
import 'package:flutter_shopping_list_tutorial/ui/add_item_dialog.dart';
import 'package:flutter_shopping_list_tutorial/ui/item_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authControllerState = useProvider(authControllerProvider);
    final itemListFilter = useProvider(itemListFilterProvider);
    final isObtainedFilter = itemListFilter.state == ItemListFilter.obtained;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping list'),
        leading: authControllerState != null
            ? IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => context.read(authControllerProvider.notifier).signOut(),
        )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              isObtainedFilter
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
            ),
            onPressed: () => itemListFilter.state =
            isObtainedFilter ? ItemListFilter.all : ItemListFilter.obtained,
          ),
        ],
      ),
      body: ProviderListener(
        provider: itemListExceptionProvider,
        onChange: (
            BuildContext context,
            StateController<CustomException?> customException,
            ) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(customException.state!.message!),
            ),
          );
        },
        child: const ItemList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => AddItemDialog.show(context, Item.empty()),
      ),
    );
  }
}