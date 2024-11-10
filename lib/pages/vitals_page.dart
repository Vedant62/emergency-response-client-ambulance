import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/emergency_case.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key, required this.sendingVitals});

  final Function(Vitals currentVitals) sendingVitals;

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  // Changed to broadcast StreamControllers
  final _heartRateController = StreamController<double>.broadcast();
  final _bloodPressureController = StreamController<String>.broadcast();
  final _oxygenSaturationController = StreamController<double>.broadcast();

  double? currentHeartRate;
  String? currentBloodPressure;
  double? currentOxygenSaturation;
  Timer? vitalsTimer;
  Timer? heartRateTimer;
  Timer? bloodPressureTimer;
  Timer? oxygenSaturationTimer;

  @override
  void initState() {
    super.initState();

    // Initialize stream listeners
    _heartRateController.stream.listen((value) => currentHeartRate = value);
    _bloodPressureController.stream.listen((value) => currentBloodPressure = value);
    _oxygenSaturationController.stream.listen((value) => currentOxygenSaturation = value);

    // Start generating vitals data
    _startGeneratingVitals();

    // Initialize sending vitals timer
    vitalsTimer = Timer.periodic(const Duration(seconds: 5), (_) => sendVitals());
  }

  void _startGeneratingVitals() {
    final random = Random();

    // Generate heart rate data
    heartRateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_heartRateController.isClosed) {
        _heartRateController.add(60 + random.nextInt(40).toDouble());
      }
    });

    // Generate blood pressure data
    bloodPressureTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bloodPressureController.isClosed) {
        final systolic = 110 + random.nextInt(20);
        final diastolic = 70 + random.nextInt(10);
        _bloodPressureController.add("$systolic/$diastolic mmHg");
      }
    });

    // Generate oxygen saturation data
    oxygenSaturationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_oxygenSaturationController.isClosed) {
        _oxygenSaturationController.add(90 + random.nextDouble() * 10);
      }
    });
  }

  void sendVitals() {
    if (currentHeartRate != null && currentBloodPressure != null && currentOxygenSaturation != null) {
      final vitals = Vitals(
        heartRate: currentHeartRate,
        bloodPressure: currentBloodPressure,
        oxygenSaturation: currentOxygenSaturation,
      );
      widget.sendingVitals(vitals);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Vitals'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<double>(
                  stream: _heartRateController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildVitalRow('Heart Rate:', '--');
                    }
                    final heartRate = snapshot.data?.toStringAsFixed(1) ?? '--';
                    return _buildVitalRow('Heart Rate:', '$heartRate bpm');
                  },
                ),
                const SizedBox(height: 16),
                StreamBuilder<String>(
                  stream: _bloodPressureController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildVitalRow('Blood Pressure:', '--');
                    }
                    final bloodPressure = snapshot.data ?? '--';
                    return _buildVitalRow('Blood Pressure:', bloodPressure);
                  },
                ),
                const SizedBox(height: 16),
                StreamBuilder<double>(
                  stream: _oxygenSaturationController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildVitalRow('Oxygen Saturation:', '--');
                    }
                    final oxygenSaturation = snapshot.data?.toStringAsFixed(1) ?? '--';
                    return _buildVitalRow('Oxygen Saturation:', '$oxygenSaturation %');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontWeight: FontWeight.w300, fontSize: 25),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 27),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    vitalsTimer?.cancel();
    heartRateTimer?.cancel();
    bloodPressureTimer?.cancel();
    oxygenSaturationTimer?.cancel();

    _heartRateController.close();
    _bloodPressureController.close();
    _oxygenSaturationController.close();

    super.dispose();
  }
}