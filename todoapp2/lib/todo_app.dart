import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp2/providers/all_providers.dart';
import 'package:todoapp2/widgets/title_widget.dart';
import 'package:todoapp2/widgets/todolist_item_widget.dart';
import 'package:todoapp2/widgets/toolbar_widget.dart';

class TodoApp extends ConsumerWidget {
  TodoApp({super.key});
  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTodos = ref.watch(filteredTodoList);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          const TitleWidget(),
          TextField(
            controller: newTodoController,
            decoration:
                const InputDecoration(labelText: 'Neler Yapıcaksın Bugün'),
            onSubmitted: (newtodo) {
              ref.read(todoListProvider.notifier).addTodo(newtodo);
            },
          ),
          const SizedBox(height: 20),
          ToolBarWidget(),
          allTodos.isEmpty
              ? const Center(child: Text('Herhangi Bir Görev Yok'))
              : const SizedBox(),
          for (var i = 0; i < allTodos.length; i++)
            Dismissible(
              onDismissed: (_) {
                ref.read(todoListProvider.notifier).remove(allTodos[i]);
              },
              key: ValueKey(allTodos[i].id),
              child: ProviderScope(overrides: [
                currentTodoProvider.overrideWithValue(allTodos[i])
              ], child: const TodoListItemWidget()),
            ),
        ], // Children
      ),
    );
  }
}
