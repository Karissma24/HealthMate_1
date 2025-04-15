import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class HealthMateConsultationDB {
  Database? _database;

  Future<Database> getHealthMateDB() async {
    if (_database != null) return _database!;

    String dbPath = join(await getDatabasesPath(), 'healthmate.db');

    _database = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await _setUpConsultationDB(db);
      },
    );

    debugPrint("HealthMate consultation database is ready for use!");
    return _database!;
  }

  Future<void> _setUpConsultationDB(Database db) async {
    debugPrint("🛠️ Setting up HealthMate’s consultation records...");
    await db.execute('''
      CREATE TABLE consultations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER,  
        symptoms TEXT,
        ai_diagnosis TEXT,
        symptom_start_date TEXT,
        consultation_date TEXT
      )
    ''');
    debugPrint("HealthMate is ready to track consultations!");
  }

  Future<void> logConsultation(
    int patientId,
    String symptoms,
    String aiDiagnosis,
    String symptomStartDate,
  ) async {
    final db = await getHealthMateDB();

    Map<String, dynamic> consultationData = {
      'patient_id': patientId,
      'symptoms': symptoms,
      'ai_diagnosis': aiDiagnosis,
      'symptom_start_date': symptomStartDate,
      'consultation_date': DateTime.now().toString(),
    };

    debugPrint("Logging consultation for patient ID: $patientId...");
    await db.insert('consultations', consultationData);
    debugPrint("Consultation saved successfully!");
  }

  Future<List<Map<String, dynamic>>> getPatientConsultations(
    int patientId,
  ) async {
    final db = await getHealthMateDB();
    debugPrint("📂 Retrieving consultations for patient ID: $patientId...");
    List<Map<String, dynamic>> consultations = await db.query(
      'consultations',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );
    debugPrint("Found ${consultations.length} consultations.");
    return consultations;
  }

  Future<Map<String, dynamic>?> getConsultationById(int consultationId) async {
    final db = await getHealthMateDB();
    debugPrint("🔍 Searching for consultation ID: $consultationId...");
    List<Map<String, dynamic>> consultations = await db.query(
      'consultations',
      where: 'id = ?',
      whereArgs: [consultationId],
    );
    return consultations.isNotEmpty ? consultations.first : null;
  }

  Future<void> updateConsultation(
    int consultationId,
    String symptoms,
    String aiDiagnosis,
    String symptomStartDate,
  ) async {
    final db = await getHealthMateDB();

    Map<String, dynamic> updatedData = {
      'symptoms': symptoms,
      'ai_diagnosis': aiDiagnosis,
      'symptom_start_date': symptomStartDate,
    };

    debugPrint("Updating consultation ID: $consultationId...");
    await db.update(
      'consultations',
      updatedData,
      where: 'id = ?',
      whereArgs: [consultationId],
    );
    debugPrint("Consultation updated successfully!");
  }

  Future<void> removeConsultation(int consultationId) async {
    final db = await getHealthMateDB();
    debugPrint("Removing consultation ID: $consultationId...");
    await db.delete(
      'consultations',
      where: 'id = ?',
      whereArgs: [consultationId],
    );
    debugPrint("Consultation ID $consultationId removed successfully!");
  }
}
