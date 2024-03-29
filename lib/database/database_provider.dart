import 'package:sqflite/sqflite.dart';

import '../model/pontos_turisticos.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_pontos.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${PontosTuristicos.nomeTabela} (
        ${PontosTuristicos.campoId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontosTuristicos.campoNome} TEXT NOT NULL,
        ${PontosTuristicos.campoDescricao} TEXT NOT NULL,
        ${PontosTuristicos.campoDiferenciais} TEXT,
        ${PontosTuristicos.campoPrazo} TEXT,
        ${PontosTuristicos.campoFinalizada} INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}