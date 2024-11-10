import 'dart:ffi';

class Location {
  const Location({required this.lat, required this.lng});
  final double lat;
  final double lng;

  Map<String, dynamic> toMap() {
    return {
      'lat': this.lat,
      'lng': this.lng,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }
}