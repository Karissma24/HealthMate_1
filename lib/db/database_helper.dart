import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class HealthMateDatabase {
  Database? _database;

  Future<Database> getHealthMateDB() async {
    if (_database != null) return _database!;

    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, 'healthmate.db');

    _database = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await _setUpDatabase(db);
      },
    );

    debugPrint("HealthMate database is ready for use!");
    return _database!;
  }

  Future<void> _setUpDatabase(Database db) async {
    debugPrint("Setting up HealthMate’s patient records...");
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,  
        email TEXT,
        full_name TEXT,
        age INTEGER,  
        gender TEXT,
        medical_history TEXT,
        allergies TEXT
      )
    ''');
    debugPrint("HealthMate is ready to track patient data!");
  }

  Future<void> addPatient(
    String username,
    String email,
    String fullName,
    int age,
    String gender,
    String medicalHistory,
    String allergies,
  ) async {
    final db = await getHealthMateDB();

    Map<String, dynamic> patientData = {
      'username': username,
      'email': email,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'medical_history': medicalHistory,
      'allergies': allergies,
    };

    debugPrint("Registering patient: $fullName...");
    await db.insert('patients', patientData);
    debugPrint("$fullName has been successfully registered in HealthMate!");
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    final db = await getHealthMateDB();
    debugPrint("Retrieving patient records...");
    List<Map<String, dynamic>> patients = await db.query('patients');
    debugPrint("Found ${patients.length} patient(s) in the system.");
    return patients;
  }

  Future<void> deletePatient(int id) async {
    final db = await getHealthMateDB();
    debugPrint("Removing patient ID: $id...");
    await db.delete('patients', where: 'id = ?', whereArgs: [id]);
    debugPrint("Patient ID $id has been removed from HealthMate.");
  }
}
