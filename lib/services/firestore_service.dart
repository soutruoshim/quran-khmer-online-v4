import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }


  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
  Stream<List<T>> searchAllCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
    String searchKeyWord
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if(searchKeyWord.length > 0){
      print('search: $searchKeyWord');
      query = FirebaseFirestore.instance.collection(path)
          .where('name', isGreaterThanOrEqualTo: searchKeyWord);
    }
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> searchCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
    String searchKeyWord
  }) {
    Query query = FirebaseFirestore.instance.collection(path).where('role', isEqualTo: 'teacher').orderBy('online', descending: true);
    if(searchKeyWord.length > 0){
       print('search: $searchKeyWord');
       query = FirebaseFirestore.instance.collection(path)
           .where('role', isEqualTo: 'teacher')
           .where('name', isGreaterThanOrEqualTo: searchKeyWord);
    }
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
