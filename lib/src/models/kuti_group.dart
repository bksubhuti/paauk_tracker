// To parse this JSON data, do
//
//     final WorldCities = WorldCitiesFromJson(jsonString);

import 'dart:convert';

List<KutiGroup> kutiGroupDetailsFromJson(String str) =>
    List<KutiGroup>.from(json.decode(str).map((x) => KutiGroup.fromJson(x)));

String kutiGroupDetailsToJson(List<KutiGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KutiGroup {
  KutiGroup({this.kutiGroup = ""});

  String kutiGroup;

  factory KutiGroup.fromJson(Map<dynamic, dynamic> json) {
    return KutiGroup(
      kutiGroup: json["kuti_group"] ?? "n/a",
    );
  }

  Map<String, dynamic> toJson() => {
        "kuti_group": kutiGroup,
      };
}
