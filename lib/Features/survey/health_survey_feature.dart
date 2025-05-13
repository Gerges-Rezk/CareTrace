import 'package:flutter/material.dart';
import 'survey_form.dart';

class HealthSurveyFeature extends StatelessWidget {
  const HealthSurveyFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const SurveyHomeScreen();
  }
}

class SurveyHomeScreen extends StatelessWidget {
  const SurveyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SurveyForm(),
    );
  }
}
