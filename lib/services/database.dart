import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/user.dart';
import 'dart:convert';

import 'package:todo/shared/constants.dart';

abstract class BaseDatabaseService {
  // On user sign up this method is used to add the newly created user to the users collection in Firestore
  Future addUserToUsersCollection(User user);

  Future addNewTaskToUserTasks(User user, Task task);

  Future removeTaskFromUserTasks(User user, Task task);

  Future finishTask(User user, String taskId);

  Future undoFinishedTask(User user, String taskId);

  Future addNewCategoryToUserCategories(User user, TaskCategory category);

  Future getAllUserCategoriesNames(User user);

  Future createDefaultCategoryOnUserSignUp(User user);
}

class DatabaseService implements BaseDatabaseService {
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference tasksCollection = Firestore.instance.collection("tasks");
  final CollectionReference categoriesCollection = Firestore.instance.collection("categories");

  List<Task> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((document) => Task.fromStream(
            taskId: document.documentID,
            title: document.data['title'],
            description: document.data['description'],
            due: DateTime.parse(document.data['due']),
            category: TaskCategory.getAllCategories(
                id: document.data['category']['id'], name: document.data['category']['name']),
            isDone: document.data['isDone']))
        .toList();
  }

  Stream<List<Task>> getUserTasks(String userId) {
    return tasksCollection.document(userId).collection("userTasks").snapshots().map(_tasksListFromSnapshot);
  }

  @override
  Future addUserToUsersCollection(User user) async {
    return await usersCollection.document(user.uid).setData(JsonMapper.toMap(user));
  }

  @override
  Future addNewTaskToUserTasks(User user, Task task) async {
    return await tasksCollection.document(user.uid).collection("userTasks").add(JsonMapper.toMap(task));
  }

  @override
  Future finishTask(User user, String taskId) async {
    return await tasksCollection
        .document(user.uid)
        .collection("userTasks")
        .document(taskId)
        .updateData({'isDone': true});
  }

  @override
  Future undoFinishedTask(User user, String taskId) async {
    return await tasksCollection
        .document(user.uid)
        .collection("userTasks")
        .document(taskId)
        .updateData({'isDone': false});
  }

  @override
  Future addNewCategoryToUserCategories(User user, TaskCategory category) async {
    print(JsonMapper.toMap(category).toString());
    return await categoriesCollection.document(user.uid).collection("userCategories").add(JsonMapper.toMap(category));
  }

  @override
  Future<List<TaskCategory>> getAllUserCategoriesNames(User user) async {
    var snapshot = await categoriesCollection.document(user.uid).collection("userCategories").getDocuments();
    return snapshot.documents
        .map((e) => TaskCategory.getAllCategories(id: e.documentID.toString(), name: e.data['name'].toString()))
        .toList();
  }

  @override
  Future createDefaultCategoryOnUserSignUp(User user) async {
    TaskCategory defaultCategory = TaskCategory(name: DEFAULT_CATEGORY_NAME);
    return addNewCategoryToUserCategories(user, defaultCategory);
  }

  @override
  Future removeTaskFromUserTasks(User user, Task task) async {
    return await tasksCollection.document(user.uid).collection("userTasks").document(task.taskId).delete();
  }
}
