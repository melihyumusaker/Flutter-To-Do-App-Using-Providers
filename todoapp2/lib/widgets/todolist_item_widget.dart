import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp2/providers/all_providers.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {
  const TodoListItemWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textFocusNode.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTodoItem = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          setState(
            () {
              _hasFocus = false;
            },
          );

          ref
              .read(todoListProvider.notifier)
              .edit(id:currentTodoItem.id, newDescription: _textController.text);
        }
      },
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
          });
          _textFocusNode.requestFocus();
          _textController.text = currentTodoItem.description;
        },
        leading: Checkbox(
          value: currentTodoItem.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toogle(currentTodoItem.id);
          },
        ),
        title: _hasFocus
            ? TextField(
                controller: _textController,
                focusNode: _textFocusNode,
              )
            : Text(currentTodoItem.description),
      ),
    );
  }
}
