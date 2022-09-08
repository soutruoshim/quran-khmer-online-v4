// To parse this JSON data, do
//
//     final surah = surahFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Surah> surahFromJson(String str) => List<Surah>.from(json.decode(str).map((x) => Surah.fromJson(x)));

String surahToJson(List<Surah> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Surah {
  Surah({
    @required this.id,
    @required this.bismillah,
    @required this.count,
    @required this.name,
    @required this.place,
    @required this.translatedAr,
    @required this.translatedEn,
    @required this.type,
  });

  int id;
  bool bismillah;
  int count;
  String name;
  String place;
  String translatedAr;
  String translatedEn;
  String type;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
    id: json["id"] == null ? null : json["id"],
    bismillah: json["bismillah"] == null ? null : json["bismillah"],
    count: json["count"] == null ? null : json["count"],
    name: json["name"] == null ? null : json["name"],
    place: json["place"] == null ? null : json["place"],
    translatedAr: json["translated_ar"] == null ? null : json["translated_ar"],
    translatedEn: json["translated_en"] == null ? null : json["translated_en"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "bismillah": bismillah == null ? null : bismillah,
    "count": count == null ? null : count,
    "name": name == null ? null : name,
    "place": place == null ? null : place,
    "translated_ar": translatedAr == null ? null : translatedAr,
    "translated_en": translatedEn == null ? null : translatedEn,
    "type": type == null ? null : type,
  };
}
