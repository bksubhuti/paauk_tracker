// To parse this JSON data, do
//
//     final WorldCities = WorldCitiesFromJson(jsonString);

import 'dart:convert';

List<ResidentDetails> worldCitiesFromJson(String str) =>
    List<ResidentDetails>.from(
        json.decode(str).map((x) => ResidentDetails.fromJson(x)));

String worldCitiesToJson(List<ResidentDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResidentDetails {
  ResidentDetails({
    this.kuti = "",
    // ignore: non_constant_identifier_names
    this.id_code = "",
    // ignore: non_constant_identifier_names
    this.passport_name = "",
    this.country = "",
    // ignore: non_constant_identifier_names
    this.ordination_state = "",
    // ignore: non_constant_identifier_names
    this.dhamma_name = "",
  });

  String kuti;
  // ignore: non_constant_identifier_names
  String id_code;
  // ignore: non_constant_identifier_names
  String passport_name;
  String country;
  // ignore: non_constant_identifier_names
  String ordination_state;
  // ignore: non_constant_identifier_names
  String dhamma_name;

  factory ResidentDetails.fromJson(Map<dynamic, dynamic> json) {
    return ResidentDetails(
      kuti: json["kuti"] ?? "n/a",
      id_code: json["id_codeode"] ?? "n/a",
      passport_name: json["passport_name"] ?? "n/a",
      country: json["country"] ?? "n/a",
      ordination_state: json["ordination_state"] ?? "n/a",
      dhamma_name: json["dhamma_name"] ?? "n/a",
    );
  }

  Map<String, dynamic> toJson() => {
        "kuti": kuti,
        "iDCode": id_code,
        "passportName": passport_name,
        "country: json": country,
        "ordinationState": ordination_state,
        "dhammaName": dhamma_name,
      };
}
