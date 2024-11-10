import 'location.dart';

class Ambulance {
  Ambulance({required this.ambulanceId, required this.availability, required this.equipment, required this.location, required this.team});

  final String ambulanceId;
  Availability availability = Availability.available; //make as engaged when registering ambulance
  Location location;
  final AmbulanceTeam team;
  final List<String> equipment;

  Map<String, dynamic> toMap() {
    return {
      'ambulanceId': this.ambulanceId,
      'availability': availability.toString().split('.').last,
      'location': this.location.toMap(),
      'team': this.team.toMap(),
      'equipment': this.equipment,
    };
  }

  factory Ambulance.fromMap(Map<String, dynamic> map) {
    return Ambulance(
      ambulanceId: map['ambulanceId'],
      availability: (map['availability'] as String).toAvailability(),
      location: Location.fromMap(map['location']),
      team: AmbulanceTeam.fromMap(map['team']),
      equipment: List<String>.from(map['equipment']),
    );
  }
}

extension AvailabilityExtension on String {
  Availability toAvailability() {
    return Availability.values.firstWhere(
          (e) => e.toString().split('.').last == this,
      orElse: () => Availability.available,
    );
  }
}

enum Availability {
  engaged,
  available
}



class AmbulanceTeam{
  const AmbulanceTeam({required this.driver, required this.paramedic});
  final String paramedic;
  final String driver;

  Map<String, dynamic> toMap() {
    return {
      'paramedic': this.paramedic,
      'driver': this.driver,
    };
  }

  factory AmbulanceTeam.fromMap(Map<String, dynamic> map) {
    return AmbulanceTeam(
      paramedic: map['paramedic'] as String,
      driver: map['driver'] as String,
    );
  }
}