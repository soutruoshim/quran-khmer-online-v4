class APIPath{
  static String account(String uid) => '/users/$uid';
  static String accounts() => '/users';
  static String schedules(String day) => '/schedules/$day/schedule';
  static String schedule(String day, String id) => '/schedules/$day/schedule/$id';


  static String job(String uid, String jobId) => '/users/$uid/jobs/$jobId';
  static String jobs(String uid) => '/users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';

}