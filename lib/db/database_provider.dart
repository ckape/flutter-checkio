import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timefly/models/habit.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  ///my database
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'habitDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating habit table");
        await database.execute(
          "CREATE TABLE habits ("
          "id TEXT,"
          "name TEXT,"
          "iconPath TEXT,"
          "mainColor INTEGER,"
          "mark TEXT,"
          "remindTimes TEXT,"
          "period INTEGER,"
          "createTime INTEGER,"
          "modifyTime INTEGER,"
          "completed INTEGER,"
          "doNum INTEGER,"
          "records TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    var habits = await db.query('habits');
    List<Habit> habitList = [];
    habits.forEach((element) {
      habitList.add(Habit.fromJson(element));
    });

    return habitList;
  }

  ///获取天数分类习惯个数，用于’我的一天‘页面分类
  Future<int> getPeriodHabitsSize(int period) async {
    final db = await database;
    var habits =
        await db.query('habits', where: 'period = ?', whereArgs: [period]);
    return habits.length;
  }

  Future<Habit> insert(Habit habit) async {
    final db = await database;
    var queryHabits =
        await db.query('habits', where: 'id = ?', whereArgs: [habit.id]);
    bool exist = false;
    queryHabits.forEach((element) {
      if (element['id'] == habit.id) {
        exist = true;
      }
    });
    if (exist) {
      print('habit has exits');
      return null;
    }
    await db.insert('habits', habit.toJson());
    return habit;
  }
}