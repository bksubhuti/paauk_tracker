// To parse this JSON data, do

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
      // ignore: non_constant_identifier_names
      this.passport_name = "",
      this.kuti = "",
      this.country = "",
      // ignore: non_constant_identifier_names
      this.id_code = "",
      // ignore: non_constant_identifier_names
      this.stime = "",
      // ignore: non_constant_identifier_names
      this.teacher = "",
      this.pk = 0});

  // ignore: non_constant_identifier_names
  String dhamma_name;
  // ignore: non_constant_identifier_names
  String passport_name;
  String kuti;
  String country;
  // ignore: non_constant_identifier_names
  String id_code;
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  String stime;
  // ignore: non_constant_identifier_names
  String teacher;
  int pk;

  factory InterviewDetails.fromJson(Map<dynamic, dynamic> json) {
    return InterviewDetails(
      dhamma_name: json["dhamma_name"] ?? "n/a",
      passport_name: json["passport_name"] ?? "n/a",
      kuti: json["kuti"] ?? "n/a",
      country: json["country"] ?? "n/a",
      id_code: json["id_code"] ?? "n/a",
      stime: json["stime"] ?? "n/a",
      teacher: json["teacher"] ?? "n/a",
      pk: json["pk"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "dhamma_name": dhamma_name,
        "passport_name": passport_name,
        "kuti": kuti,
        "country: json": country,
        "iDCode": id_code,
        "stime": stime,
        "teacher": teacher,
        "pk": pk,
      };
}
