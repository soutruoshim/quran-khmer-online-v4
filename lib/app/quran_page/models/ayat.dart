// To parse this JSON data, do
//
//     final ayat = ayatFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Ayat> ayatFromJson(String str) => List<Ayat>.from(json.decode(str).map((x) => Ayat.fromJson(x)));

String ayatToJson(List<Ayat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ayat {
  Ayat({
    @required this.id,
    @required this.suraId,
    @required this.verseId,
    @required this.ayahText,
    @required this.ayahTextKhmer,
    @required this.ayahNormal,
    @required this.surahName,
  });

  String id;
  String suraId;
  String verseId;
  String ayahText;
  String ayahTextKhmer;
  String ayahNormal;
  String surahName;

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
    id: json["ID"] == null ? null : json["ID"],
    suraId: json["SuraID"] == null ? null : json["SuraID"],
    verseId: json["VerseID"] == null ? null : json["VerseID"],
    ayahText: json["AyahText"] == null ? null : json["AyahText"],
    ayahTextKhmer: json["AyahTextKhmer"] == null ? null : json["AyahTextKhmer"],
    ayahNormal: json["AyahNormal"] == null ? null : json["AyahNormal"],
    surahName: json["SurahName"] == null ? null : json["SurahName"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
    "SuraID": suraId == null ? null : suraId,
    "VerseID": verseId == null ? null : verseId,
    "AyahText": ayahText == null ? null : ayahText,
    "AyahTextKhmer": ayahTextKhmer == null ? null : ayahTextKhmer,
    "AyahNormal": ayahNormal == null ? null : ayahNormal,
    "SurahName": surahName == null ? null : surahName,
  };
}
