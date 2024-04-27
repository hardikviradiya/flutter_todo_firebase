import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/User.dart';
import '../model/todo.dart';
import '../utils/shared_preference_helper.dart';

class FirebaseApi {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserDetails(String userId) async {
    try {
      // Store user details in Firestore
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
      });

      // Store user details in SharedPreferences
      SharedPreferenceHelper().userId = userId;

    } catch (e) {
      print('Error storing user details: $e');
      throw Exception('Failed to store user details');
    }
  }

  Future<String> createTodo(Todo todo) async {
    final docTodo = _firestore.collection('todo').doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  Future<User?> getUserDetails(String deviceId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('users').doc(deviceId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data()!;

        // Store user details in SharedPreferences
        SharedPreferenceHelper().userId = userSnapshot.id;

        return User(
          id: userSnapshot.id,
        );
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error checking user registration: $e');
      return null;
    }
  }

  Future<List<Todo>> readTodos(String id) async {
    List<Todo> list = [];
    await _firestore
        .collection('todo')
        .where('userId', isEqualTo: id)
        .orderBy('createdTime', descending: true)
        .get()
        .then((value) {
      for (var docSnapshot in value.docs) {
        list.add(Todo.fromJson(docSnapshot.data()));
      }
    });
    return list;
  }

  Future updateTodo(Todo todo) async {
    final docTodo = _firestore.collection('todo').doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  Future deleteTodo(Todo todo) async {
    final docTodo = _firestore.collection('todo').doc(todo.id);

    await docTodo.delete();
  }
}
