import 'package:ambulance_app/ambulance_app.dart';
import 'package:ambulance_app/models/ambulance.dart';
import 'package:ambulance_app/models/location.dart';
import 'package:ambulance_app/utils/string_splitter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AmbulanceRegisterPage extends StatefulWidget {
  const AmbulanceRegisterPage({super.key});

  @override
  State<AmbulanceRegisterPage> createState() => _AmbulanceRegisterPageState();
}

class _AmbulanceRegisterPageState extends State<AmbulanceRegisterPage> {
  final TextEditingController _ambulanceNoController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _paramedicController = TextEditingController();

  final TextEditingController _equipmentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Stream<Position> _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );

  Future<Position> _getCurrentLocation() async{
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    return position;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Ambulance'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Ambulance information',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _ambulanceNoController,
                              decoration: const InputDecoration(
                                  label: Text('Ambulance No'),
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
                                  return 'enter ambulance number';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  label: Text('Driver'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              controller: _driverController,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter driver name';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Paramedic'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              keyboardType: TextInputType.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              controller: _paramedicController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter paramedic name';
                                }
                                return null;
                              }),
                        ),
                      ],
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
                                  label: Text('Equipments'),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              keyboardType: TextInputType.text,
                              controller: _equipmentController,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter equipments';
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Position loc = await _getCurrentLocation();
                        Ambulance ambulance = Ambulance(
                          ambulanceId: _ambulanceNoController.text,
                          equipment: splitCommaSeparatedString(
                              _equipmentController.text),
                          location: Location(lat: loc.latitude, lng: loc.longitude),
                          availability: Availability.engaged,
                          team: AmbulanceTeam(
                              driver: _driverController.text,
                              paramedic: _paramedicController.text),
                        );

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                AmbulanceApp(ambulance: ambulance),
                          ),
                        );
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
                ),
                StreamBuilder<Position>(
                  stream: _positionStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Waiting for location...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final position = snapshot.data!;
                      return Text(
                        'Current Position: Lat: ${position.latitude}, Long: ${position.longitude}',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      );
                    } else {
                      return Text('No location data available');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
