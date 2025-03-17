import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'registros.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            sexo TEXT,
            fecha TEXT,
            telefono TEXT,
            direccion TEXT,
            esCristiano INTEGER,
            asisteOtraIglesia INTEGER,
            notas TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await database;
    return await db.insert('registros', registro);
  }

  Future<List<Map<String, dynamic>>> getRegistros() async {
    final db = await database;
    return await db.query('registros', orderBy: 'fecha DESC');
  }

  Future<void> updateRegistro(int id, Map<String, dynamic> registro) async {
    final db = await database;
    await db.update('registros', registro, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRegistro(int id) async {
    final db = await database;
    await db.delete('registros', where: 'id = ?', whereArgs: [id]);
  }
}
