class Place {
  String place;
  String city;

  Place({this.place, this.city});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
      place: parsedJson['place'] as String,
      city: parsedJson['city'] as String,
    );
  }
}
