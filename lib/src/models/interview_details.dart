// To parse this JSON data, do
//
//     final WorldCities = WorldCitiesFromJson(jsonString);

import 'dart:convert';

List<InterviewDetails> interviewDetailsFromJson(String str) =>
    List<InterviewDetails>.from(
        json.decode(str).map((x) => InterviewDetails.fromJson(x)));

String interviewDetailsToJson(List<InterviewDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterviewDetails {
  InterviewDetails(
      // ignore: non_constant_identifier_names
      {this.dhamma_name = "",
      this.kuti = "",
      this.country = "",
      // ignore: non_constant_identifier_names
      this.id_code = "",
      // ignore: non_constant_identifier_names
      this.sdate = "",
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
  String sdate;
  // ignore: non_constant_identifier_names
  int real_time;
  String teacher;

  factory InterviewDetails.fromJson(Map<dynamic, dynamic> json) {
    return InterviewDetails(
      dhamma_name: json["dhamma_name"] ?? "n/a",
      kuti: json["kuti"] ?? "n/a",
      country: json["country"] ?? "n/a",
      id_code: json["id_code"] ?? "n/a",
      sdate: json["sdate"] ?? "n/a",
      real_time: json["real_time"] ?? 0,
      teacher: json["teacher"] ?? "n/a",
    );
  }

  Map<String, dynamic> toJson() => {
        "dhammaName": dhamma_name,
        "kuti": kuti,
        "country: json": country,
        "iDCode": id_code,
        "sdate": sdate,
        "real_time": real_time,
        "teacher": teacher,
      };
}
