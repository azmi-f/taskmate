import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap(
                  doc.id,
                  doc.data(),
                ))
            .toList());
    }

  Future<void> updateTask(TaskModel task) async {
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  Future<void> updateStatus(
      String id,
      bool completed,
      ) async {
    await _firestore.collection('tasks').doc(id).update({
      'isCompleted': completed,
    });
  }
}