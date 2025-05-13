import 'package:flutter/foundation.dart';
import 'survey_data.dart';
import 'database_helper.dart';

class SurveyProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<SurveyData> _surveys = [];

  SurveyProvider() {
    loadSurveys();
  }

  List<SurveyData> get surveys => List.unmodifiable(_surveys);

  Future<void> loadSurveys() async {
    _surveys = await _dbHelper.getSurveys();
    notifyListeners();
  }

  Future<void> addSurvey(SurveyData survey) async {
    await _dbHelper.insertSurvey(survey);
    await loadSurveys(); // Reload all surveys after adding
    notifyListeners();
  }

  Future<void> deleteSurvey(String nationalId) async {
    await _dbHelper.deleteSurvey(nationalId);
    await loadSurveys(); // Reload all surveys after deleting
    notifyListeners();
  }
}
