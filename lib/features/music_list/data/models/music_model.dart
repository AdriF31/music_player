// To parse this JSON data, do
//
//     final itunesModel = itunesModelFromJson(jsonString);

import 'dart:convert';

import 'package:music_player/features/music_list/domain/entities/music_entity.dart';

MusicModel musicModelFromJson(String str) =>
    MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel extends MusicEntity {
  @override
  final int? resultCount;
  @override
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
  @override
  final String? artistName;
  @override
  final String? image;
  @override
  final String? collectionExplicitness;
  @override
  final int? trackCount;
  @override
  final String? copyright;
  @override
  final String? country;
  @override
  final String? primaryGenreName;
  @override
  final String? previewUrl;
  @override
  final String? description;
  @override
  final String? kind;
  @override
  final int? trackId;
  @override
  final String? trackName;
  @override
  final String? trackViewUrl;
  @override
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
