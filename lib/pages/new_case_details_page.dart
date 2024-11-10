import 'package:ambulance_app/utils/string_splitter.dart';
import 'package:flutter/material.dart';

import '../models/emergency_case.dart';

class NewCaseDetailsPage extends StatefulWidget {
  const NewCaseDetailsPage({super.key, required this.newCaseSubmitHandler, required this.handleUIAfterNewCase});

  final Function(EmergencyCase emergencyCase) newCaseSubmitHandler;
  final Function() handleUIAfterNewCase;

  @override
  State<NewCaseDetailsPage> createState() => _NewCaseDetailsPageState();
}

class _NewCaseDetailsPageState extends State<NewCaseDetailsPage> {
  TextEditingController _patientConditionController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _severityController = TextEditingController();

  TextEditingController _heartRateController = TextEditingController();
  TextEditingController _bloodPressureController = TextEditingController();
  TextEditingController _oxygenSaturationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New case details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Patient information',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _patientConditionController,
                              decoration: const InputDecoration(
                                  label: Text('Patient Condition'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient condition';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Age'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              controller: _ageController,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient age';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              controller: _genderController,
                              decoration: const InputDecoration(
                                  label: Text('Gender'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              keyboardType: TextInputType.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient gender';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Symptoms'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              keyboardType: TextInputType.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              controller: _symptomsController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient symptoms';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              controller: _severityController,
                              decoration: const InputDecoration(
                                  label: Text('Severity'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient severity';
                                }
                                return null;
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Patient vitals',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Heart Rate'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              keyboardType: TextInputType.number,
                              controller: _heartRateController,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient heart rate';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Blood Pressure'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              controller: _bloodPressureController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient blood pressure';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Oxygen Saturation'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              controller: _oxygenSaturationController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter patient oxygen saturation';
                                }
                                return null;
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        EmergencyCase emergencyCase = EmergencyCase(
                          patientInfo: PatientInfo(
                              age: int.parse(_ageController.text),
                              condition: _patientConditionController.text,
                              gender: _genderController.text == 'Male'
                                  ? Gender.male
                                  : Gender.female,
                              symptoms: splitCommaSeparatedString(
                                  _symptomsController.text)),
                          severity: _severityController.text == 'critical'
                              ? Severity.critical
                              : _severityController.text == 'minor'
                                  ? Severity.minor
                                  : Severity.moderate,
                          vitals: Vitals(
                              bloodPressure: _bloodPressureController.text,
                              heartRate: _heartRateController.text,
                              oxygenSaturation:
                                  _oxygenSaturationController.text),
                        );

                        widget.newCaseSubmitHandler(emergencyCase);
                        Navigator.of(context).pop();
                        widget.handleUIAfterNewCase();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
