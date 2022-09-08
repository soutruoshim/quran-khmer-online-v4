import 'package:meta/meta.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/models/schedule.dart';
import 'package:quran_khmer_online/services/api_path.dart';
import 'package:quran_khmer_online/services/firestore_service.dart';

abstract class Database {
  Future<void> setAccount(Account account);
  Future<void> deleteAccount(Account account);
  Stream<Account> accountStream({@required String accountId});
  Stream<List<Account>> accountsStream();
  Stream<List<Account>> searchAccountsStream(String searchKeyWord);
  Stream<List<Account>> searchAllAccountsStream(String searchKeyWord);
  Stream<List<Schedule>> scheduleDayStream(String day);
  Future<void> setSchedule(Schedule schedule, String day, String id);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setAccount(Account account) => _service.setData(
    path: APIPath.account(uid),
    data: account.toMap(),
  );

  @override
  Future<void> setSchedule(Schedule schedule, String day, String id) {
    print("api part:${APIPath.schedule(day, id)}");

    _service.setData(
      path: APIPath.schedule(day, id),
      data: schedule.toMap(),);
  }


  @override
  Future<void> deleteAccount(Account account) async {
    // delete Account
    await _service.deleteData(path: APIPath.account(account.id));
  }
  @override
  Future<void> deleteSchedule(String day, Schedule schedule) async {
    // delete Account
    await _service.deleteData(path: APIPath.schedule(day,schedule.id));
  }

  @override
  Stream<Account> accountStream({@required String accountId}) => _service.documentStream(
    path: APIPath.account(accountId),
    builder: (data, documentId) => Account.fromMap(data, documentId),
  );

  @override
  Stream<List<Account>> accountsStream() => _service.collectionStream(
    path: APIPath.accounts(),
    builder: (data, documentId) => Account.fromMap(data, documentId),
  );

  @override
  Stream<List<Account>> searchAllAccountsStream(String searchKeyWord) => _service.searchAllCollectionStream(
    path: APIPath.accounts(),
    searchKeyWord: searchKeyWord,
    builder: (data, documentId) => Account.fromMap(data, documentId),
  );

  @override
  Stream<List<Account>> searchAccountsStream(String searchKeyWord) => _service.searchCollectionStream(
    path: APIPath.accounts(),
    searchKeyWord: searchKeyWord,
    builder: (data, documentId) => Account.fromMap(data, documentId),
  );

  @override
  Stream<List<Schedule>> scheduleDayStream(String day) => _service.collectionStream(
    path: APIPath.schedules(day),
    builder: (data, documentId) => Schedule.fromMap(data, documentId),
  );
}
