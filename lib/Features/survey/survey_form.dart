import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'survey_data.dart';
import 'survey_provider.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({super.key});

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _chronicDisease;
  String? _allergy;
  String? _medication;
  String? _familyHistory;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final surveyData = SurveyData(
        name: _nameController.text,
        nationalId: _nationalIdController.text,
        dateOfBirth: _selectedDate!,
        phone: _phoneController.text,
        chronicDisease: _chronicDisease ?? 'Not selected',
        allergy: _allergy ?? 'Not selected',
        medication: _medication ?? 'Not selected',
        familyHistory: _familyHistory ?? 'Not selected',
      );

      try {
        await context.read<SurveyProvider>().addSurvey(surveyData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Survey submitted successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = null;
          _chronicDisease = null;
          _allergy = null;
          _medication = null;
          _familyHistory = null;
        });
        _nameController.clear();
        _nationalIdController.clear();
        _phoneController.clear();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving survey: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all required fields.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Survey'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildNationalIdField(),
                const SizedBox(height: 16),
                _buildDateOfBirthField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 32),
                _buildSectionTitle('Medical Information'),
                const SizedBox(height: 16),
                _buildChronicDiseaseField(),
                const SizedBox(height: 16),
                _buildAllergyField(),
                const SizedBox(height: 16),
                _buildMedicationField(),
                const SizedBox(height: 16),
                _buildFamilyHistoryField(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
    );
  }

  Widget _buildNationalIdField() {
    return TextFormField(
      controller: _nationalIdController,
      decoration: InputDecoration(
        labelText: 'National ID',
        prefixIcon: const Icon(Icons.badge_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your National ID';
        if (!RegExp(r'^\d{16}$').hasMatch(value)) {
          return 'National ID must be 16 digits';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    final hasError = _selectedDate == null &&
        _formKey.currentState != null &&
        !_formKey.currentState!.validate();
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          errorText: hasError ? 'Please select your date of birth' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: Text(
          _selectedDate == null
              ? 'Select Date'
              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
          style: TextStyle(
            color: _selectedDate == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your phone number';
        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
          return 'Phone number must be 11 digits';
        }
        if (!value.startsWith('01')) {
          return 'Phone number must start with 01';
        }
        return null;
      },
    );
  }

  Widget _buildChronicDiseaseField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Chronic Disease',
        prefixIcon: const Icon(Icons.medical_services_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      value: _chronicDisease,
      items: AppConstants.chronicDiseases.map((String disease) {
        return DropdownMenuItem<String>(
          value: disease,
          child: Text(disease),
        );
      }).toList(),
      onChanged: (value) => setState(() => _chronicDisease = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildAllergyField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Allergies',
        prefixIcon: const Icon(Icons.warning_amber_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      value: _allergy,
      items: AppConstants.allergies.map((String allergy) {
        return DropdownMenuItem<String>(
          value: allergy,
          child: Text(allergy),
        );
      }).toList(),
      onChanged: (value) => setState(() => _allergy = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildMedicationField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Medications',
        prefixIcon: const Icon(Icons.medication_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      value: _medication,
      items: AppConstants.medications.map((String medication) {
        return DropdownMenuItem<String>(
          value: medication,
          child: Text(medication),
        );
      }).toList(),
      onChanged: (value) => setState(() => _medication = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildFamilyHistoryField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Family History',
        prefixIcon: const Icon(Icons.family_restroom_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      value: _familyHistory,
      items: AppConstants.familyHistory.map((String history) {
        return DropdownMenuItem<String>(
          value: history,
          child: Text(history),
        );
      }).toList(),
      onChanged: (value) => setState(() => _familyHistory = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Submit Survey',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
