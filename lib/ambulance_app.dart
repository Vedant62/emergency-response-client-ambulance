import 'package:ambulance_app/pages/new_case_details_page.dart';
import 'package:ambulance_app/pages/vitals_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/ambulance.dart';
import 'models/emergency_case.dart';
import 'models/location.dart';

class AmbulanceApp extends StatefulWidget {
  const AmbulanceApp({super.key, required this.ambulance});

  final Ambulance ambulance;

  @override
  _AmbulanceAppState createState() => _AmbulanceAppState();
}

class _AmbulanceAppState extends State<AmbulanceApp> {
  late IO.Socket _socket;
  late Ambulance _ambulance;
  bool _isConnected = false;
  bool _enableVitalsUpdateUI = false;

  @override
  void initState() {
    super.initState();
    _ambulance = widget.ambulance;

    _socket = IO.io(
        'https://emergency-response-server-wiz.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Content-Type': 'application/json'},
    });

    // Set up socket event listeners
    _socket.onConnect((_) {
      print('Socket connected');
      setState(() => _isConnected = true);
      registerAmbulance(_ambulance);
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
      setState(() => _isConnected = false);
    });

    _socket.onError((error) => print('Socket error: $error'));
    _socket.onConnectError((error) => print('Connect error: $error'));
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }

  void toggleConnection() {
    try {
      if (!_isConnected) {
        print('Attempting to connect...');
        _socket.connect();
        _startSendingLocation();
      } else {
        print('Disconnecting...');
        _socket.disconnect();
      }
    } catch (e) {
      print('Error toggling connection: $e');
    }
  }

  void UIAfterNewCaseHandler() {
    setState(() {
      _enableVitalsUpdateUI = true;
    });
  }

  void _startSendingLocation() {
    final locationStream = Geolocator.getPositionStream(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));

    locationStream.listen((Position position) {
      Location location =
          Location(lat: position.latitude, lng: position.longitude);
      updateLocation(location);
    });
  }

  void registerAmbulance(Ambulance ambulance) {
    try {
      final data = ambulance.toMap();
      print('Sending ambulance data: $data');
      _socket.emit('registerAmbulance', data);
    } catch (e, stackTrace) {
      print('Error registering ambulance: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void createEmergencyCase(EmergencyCase emergencyCase) {
    try {
      if (!_isConnected) {
        throw Exception('Socket not connected');
      }
      print('The case we are sending: ${emergencyCase.toMap()}');
      _socket.emit('createEmergencyCase', emergencyCase.toMap());
    } catch (e) {
      print('Error creating emergency case: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create case: Not connected')));
    }
  }

  void updateVitals(Vitals currentVitals) {
    try {
      if (!_isConnected) {
        throw Exception('Socket not connected');
      }
      print('Sending vitals: ${currentVitals.toMap()}');
      _socket.emit('updateVitals', currentVitals.toMap());
    } catch (e) {
      print('Error updating vitals: $e');
    }
  }

  void updateLocation(Location currentLocation) {
    try {
      if (!_isConnected) {
        throw Exception('Socket not connected');
      }
      print('sending this location: ${currentLocation.toMap()}');
      _socket.emit('updateLocation', currentLocation.toMap());
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance ${_ambulance.ambulanceId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: toggleConnection,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.66,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(63, 4, 4, 4),
                          child: Icon(
                            Icons.circle,
                            color: _isConnected ? Colors.green : Colors.brown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                          child: Text(
                            _isConnected ? 'On duty' : 'Off duty',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 4),
              onPressed: _isConnected
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => NewCaseDetailsPage(
                            newCaseSubmitHandler: createEmergencyCase,
                            handleUIAfterNewCase: UIAfterNewCaseHandler,
                          ),
                        ),
                      );
                    }
                  : null, // Disable button when not connected
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Create new case',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
            ),
            _enableVitalsUpdateUI
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => VitalsPage(
                              sendingVitals: updateVitals,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width * 0.66,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(48, 4, 4, 4),
                          child: Text(
                            'Stream Vitals',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
