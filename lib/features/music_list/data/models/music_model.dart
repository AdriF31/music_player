// To parse this JSON data, do
//
//     final itunesModel = itunesModelFromJson(jsonString);

import 'dart:convert';

import 'package:music_player/features/music_list/domain/entities/music_entity.dart';

MusicModel musicModelFromJson(String str) =>
    MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel extends MusicEntity {
  final int? resultCount;
  final List<Result>? results;

  const MusicModel({
    this.resultCount,
    this.results,
  }) : super(resultCount: resultCount, results: results);

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        resultCount: json["resultCount"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result extends ResultEntity {
  final String? artistName;
  final String? image;
  final String? collectionExplicitness;
  final int? trackCount;
  final String? copyright;
  final String? country;
  final String? primaryGenreName;
  final String? previewUrl;
  final String? description;
  final String? kind;
  final int? trackId;
  final String? trackName;
  final String? trackViewUrl;
  final bool? isStreamable;

  const Result({
    this.artistName,
    this.image,
    this.collectionExplicitness,
    this.trackCount,
    this.copyright,
    this.country,
    this.primaryGenreName,
    this.previewUrl,
    this.description,
    this.kind,
    this.trackId,
    this.trackName,
    this.trackViewUrl,
    this.isStreamable,
  }) : super(
          artistName: artistName,
          trackViewUrl: trackViewUrl,
          trackName: trackName,
          trackId: trackId,
          trackCount: trackCount,
          primaryGenreName: primaryGenreName,
          previewUrl: previewUrl,
          kind: kind,
          isStreamable: isStreamable,
          image: image,
          description: description,
          country: country,
          copyright: copyright,
          collectionExplicitness: collectionExplicitness,
        );

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        artistName: json["artistName"],
        image: json["artworkUrl100"],
        collectionExplicitness: json["collectionExplicitness"],
        trackCount: json["trackCount"],
        copyright: json["copyright"],
        country: json["country"],
        primaryGenreName: json["primaryGenreName"],
        previewUrl: json["previewUrl"],
        description: json["description"],
        kind: json["kind"],
        trackId: json["trackId"],
        trackName: json["trackName"],
        trackViewUrl: json["trackViewUrl"],
        isStreamable: json["isStreamable"],
      );

  Map<String, dynamic> toJson() => {
        "artistName": artistName,
        "artworkUrl100": image,
        "collectionExplicitness": collectionExplicitness,
        "trackCount": trackCount,
        "copyright": copyright,
        "country": country,
        "primaryGenreName": primaryGenreName,
        "previewUrl": previewUrl,
        "description": description,
        "kind": kind,
        "trackId": trackId,
        "trackName": trackName,
        "trackViewUrl": trackViewUrl,
        "isStreamable": isStreamable,
      };
}
