import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static const String dbName = "giftly_endterm.db";
  static const int dbVersion = 1;

  static const String recipientTb = "recipient";
  static const String recipientColId = "recipient_id";
  static const String recipientColName = "recipient_name";
  static const String recipientColRelationship = "recipient_relationship";
  static const String recipientColBudget = "recipient_budget";

  static const String occasionTb = "occasion";
  static const String occasionColId = "occasion_id";
  static const String occasionColDate = "occasion_date";
  static const String occasionColName = "occasion_name";
  static const String occasionReminderColName = "occasion_reminder";
  static const String occasionColRecipientId = "recipient_id";

  static const String giftIdeaTb = "gift_idea";
  static const String giftIdeaColId = "gift_idea_id";
  static const String giftIdeaColName = "gift_idea_name";
  static const String giftIdeaColPrice = "gift_idea_price";
  static const String giftIdeaColRecipientId = "recipient_id";

  static const String notificationTb = "notification";
  static const String notificationColId = "notification_id";
  static const String notificationColMessage = "notification_message";

  static Future<Database> openDb() async {
    var path = join(await getDatabasesPath(), dbName);

    var createRecipientTb = '''
      CREATE TABLE IF NOT EXISTS $recipientTb (
        $recipientColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $recipientColName VARCHAR(255) NOT NULL,
        $recipientColRelationship VARCHAR(255) NOT NULL,
        $recipientColBudget DECIMAL(10,2) NOT NULL
      )
    ''';

    var createOccasionTb = '''
      CREATE TABLE IF NOT EXISTS $occasionTb (
        $occasionColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $occasionColDate DATE NOT NULL,
        $occasionColName VARCHAR(255) NOT NULL,
        $occasionColRecipientId INTEGER NOT NULL,
        $occasionReminderColName BOOLEAN NOT NULL DEFAULT 0,
        FOREIGN KEY ($occasionColRecipientId) REFERENCES $recipientTb($recipientColId)
      )
    ''';

    var createGiftIdeaTb = '''
      CREATE TABLE IF NOT EXISTS $giftIdeaTb (
        $giftIdeaColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $giftIdeaColName VARCHAR(255) NOT NULL,
        $giftIdeaColPrice DECIMAL(10,2) NOT NULL,
        $giftIdeaColRecipientId INTEGER NOT NULL,
        FOREIGN KEY ($giftIdeaColRecipientId) REFERENCES $recipientTb($recipientColId)
      )
    ''';

    var createNotificationTb = '''
      CREATE TABLE IF NOT EXISTS $notificationTb (
        $notificationColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notificationColMessage VARCHAR(255) NOT NULL
      )
    ''';

    var db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) {
        db.execute(createRecipientTb);
        db.execute(createOccasionTb);
        db.execute(createGiftIdeaTb);
        db.execute(createNotificationTb);
      },
    );

    return db;
  }

  static void insertRecipient(String recipientName,
      String recipientRelationship, double recipientBudget) async {
    var db = await openDb();
    var insertSql =
        "INSERT INTO $recipientTb VALUES(NULL, '${recipientName}', '${recipientRelationship}', ${recipientBudget})";
    var id = await db.rawInsert(insertSql);

    print(id);

    await db.close();
  }

  static void insertOccasion(
      String occasionDate, String occasionName, int recipientId) async {
    var db = await openDb();
    var insertSql =
        "INSERT INTO $occasionTb VALUES(NULL, '${occasionDate}', '${occasionName}', ${recipientId}, ${0})";
    var id = await db.rawInsert(insertSql);

    print(id);

    await db.close();
  }

  static void insertGiftIdea(
      String giftIdeaName, double giftIdeaPrice, int recipientId) async {
    var db = await openDb();
    var insertSql =
        "INSERT INTO $giftIdeaTb VALUES(NULL, '${giftIdeaName}', ${giftIdeaPrice}, ${recipientId})";
    await db.rawInsert(insertSql);

    await db.close();
  }

  static void insertNotification(String notificationMessage) async {
    var db = await openDb();

    var insertSql =
        "INSERT INTO $notificationTb VALUES(NULL, '${notificationMessage}')";

    var id = await db.rawInsert(insertSql);

    print("${id} of ${notificationMessage}");

    await db.close();
  }

  static Future<List<Map<String, dynamic>>> fetchRecipients() async {
    var db = await DbHelper.openDb();

    return await db.rawQuery("SELECT * FROM $recipientTb");
  }

  static Future<List<Map<String, dynamic>>> fetchOccasions(
      int recipientId) async {
    var db = await DbHelper.openDb();

    return await db.rawQuery(
        "SELECT * FROM $occasionTb WHERE $occasionColRecipientId = $recipientId");
  }

  static Future<List<Map<String, dynamic>>> fetchGiftIdeas(
      int recipientId) async {
    var db = await DbHelper.openDb();

    return await db.rawQuery(
        "SELECT * FROM $giftIdeaTb WHERE $giftIdeaColRecipientId = $recipientId");
  }

  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    var db = await DbHelper.openDb();

    return await db.rawQuery("SELECT * FROM $notificationTb");
  }

  static void updateRecipient(
      String recipientName,
      String recipientRelationship,
      double recipientBudget,
      int recipientId) async {
    var db = await openDb();

    var updateSql =
        "UPDATE $recipientTb SET $recipientColName = '$recipientName', $recipientColRelationship = '$recipientRelationship', $recipientColBudget = $recipientBudget WHERE $recipientColId = $recipientId";

    var id = await db.rawUpdate(updateSql);
  }

  static void updateOccasion(
    String occasionName,
    String occasionDate,
    int occasionId,
  ) async {
    var db = await openDb();

    var updateSql =
        "UPDATE $occasionTb SET $occasionColName = '$occasionName', $occasionColDate = '$occasionDate' WHERE $occasionColId = $occasionId";

    var id = await db.rawUpdate(updateSql);
  }

  static void updateOccasionReminder(int occasionId, bool reminder) async {
    var db = await openDb();

    var updateSql =
        "UPDATE $occasionTb SET $occasionReminderColName = ${reminder ? 1 : 0} WHERE $occasionColId = $occasionId";

    var id = await db.rawUpdate(updateSql);
  }

  static void updateGiftIdea(
    String giftIdeaName,
    double giftIdeaPrice,
    int giftIdeaId,
  ) async {
    var db = await openDb();

    var updateSql =
        "UPDATE $giftIdeaTb SET $giftIdeaColName = '$giftIdeaName', $giftIdeaColPrice = $giftIdeaPrice WHERE $giftIdeaColId = $giftIdeaId";

    var id = await db.rawUpdate(updateSql);
  }

  static void deleteRecipient(int recipientId) async {
    var db = await openDb();

    await db.rawDelete(
        "DELETE FROM ${recipientTb} WHERE ${recipientColId} = ${recipientId}");

    await db.rawDelete(
        "DELETE FROM $occasionTb WHERE $occasionColRecipientId = $recipientId");

    await db.rawDelete(
        "DELETE FROM $giftIdeaTb WHERE $giftIdeaColRecipientId = $recipientId");
  }

  static void deleteOccasion(int occasionId) async {
    var db = await openDb();

    await db.rawDelete(
        "DELETE FROM $occasionTb WHERE $occasionColId = $occasionId");
  }

  static void deleteGiftIdea(int giftIdeaId) async {
    var db = await openDb();

    await db.rawDelete(
        "DELETE FROM $giftIdeaTb WHERE $giftIdeaColId = $giftIdeaId");
  }
}
