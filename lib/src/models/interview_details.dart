// To parse this JSON data, do
//
//     final WorldCities = WorldCitiesFromJson(jsonString);

import 'dart:convert';

List<KutiGroup> interviewDetailsFromJson(String str) =>
    List<KutiGroup>.from(json.decode(str).map((x) => KutiGroup.fromJson(x)));

String interviewDetailsToJson(List<KutiGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KutiGroup {
  KutiGroup(
      // ignore: non_constant_identifier_names
      {this.dhamma_name = "",
      this.kuti = "",
      this.country = "",
      // ignore: non_constant_identifier_names
      this.id_code = "",
      // ignore: non_constant_identifier_names
      this.stime = "",
      // ignore: non_constant_identifier_names
      this.real_time = 0,
      this.teacher = ""});

  // ignore: non_constant_identifier_names
  String dhamma_name;
  String kuti;
  String country;
  // ignore: non_constant_identifier_names
  String id_code;
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  String stime;
  // ignore: non_constant_identifier_names
  int real_time;
  String teacher;

  factory KutiGroup.fromJson(Map<dynamic, dynamic> json) {
    return KutiGroup(
      dhamma_name: json["dhamma_name"] ?? "n/a",
      kuti: json["kuti"] ?? "n/a",
      country: json["country"] ?? "n/a",
      id_code: json["id_code"] ?? "n/a",
      stime: json["stime"] ?? "n/a",
      real_time: json["real_time"] ?? 0,
      teacher: json["teacher"] ?? "n/a",
    );
  }

  Map<String, dynamic> toJson() => {
        "dhammaName": dhamma_name,
        "kuti": kuti,
        "country: json": country,
        "iDCode": id_code,
        "stime": stime,
        "real_time": real_time,
        "teacher": teacher,
      };
}
