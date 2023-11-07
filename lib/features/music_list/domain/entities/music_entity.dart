import 'package:equatable/equatable.dart';

class MusicEntity extends Equatable {
  const MusicEntity({this.results, this.resultCount});

  final int? resultCount;
  final List<ResultEntity>? results;

  @override
  List<Object?> get props => [resultCount, results];
}

class ResultEntity extends Equatable{
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

 const ResultEntity({
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
  });

 @override
  List<Object?> get props => [   artistName,
   image,
   collectionExplicitness,
   trackCount,
   copyright,
   country,
   primaryGenreName,
   previewUrl,
   description,
   kind,
   trackId,
   trackName,
   trackViewUrl,
   isStreamable,];
}
