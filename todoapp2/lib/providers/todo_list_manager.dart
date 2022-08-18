import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp2/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    // ekleme yapma
    var eklenecekTodo =
        TodoModel(id: const Uuid().v4(), description: description);
    state = [...state, eklenecekTodo]; //sürekli state güncelleniyor
  }

  void toogle(String id) {
    // tıklanma
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed)
        else
          todo
    ];
  }

  void edit({required String id, required String newDescription}) {
    // değiştirme
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: newDescription,
              completed: todo.completed)
        else
          todo
    ];
  }

  void remove(TodoModel silinecekTodo) {
    // her elemanı geziyor id leri eşit olmayanı yeni stateye atıyor id si eşit olanı atmicak ve böylece silinmiş oluyor
    state = state.where((element) => element.id != silinecekTodo.id).toList();
  }

  int onCompletedTodoCount() {
    return state.where((element) => !element.completed).length;
  }
}
