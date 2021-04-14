class PlacePrediction {
  String secondary_text;
  String main_text;
  String place_id;

  PlacePrediction({this.main_text, this.place_id, this.secondary_text});

  PlacePrediction.fromJson(Map<String, dynamic> parsedJson) {
    place_id = parsedJson["place_id"];
    main_text = parsedJson["structured_formatting"]["main_text"];
    secondary_text = parsedJson["structured_formatting"]["secondary_text"];
  }
}
