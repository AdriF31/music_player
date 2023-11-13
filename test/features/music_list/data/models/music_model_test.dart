import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/features/music_list/data/models/music_model.dart';
import 'package:music_player/features/music_list/domain/entities/music_entity.dart';

import '../../../../helpers/json_reader.dart';

void main(){
  const testMusicModel = MusicModel(
    resultCount: 1,
    results:  [Result(
        artistName: "Joe Jacks, Pete Bruen, Michael Hans & Marie Hass",
        collectionExplicitness: "notExplicit",
        copyright: "© 2010 John Brown Rockview",
        country: "USA",
        description: "Shock, controversy and pathological rage are the order of the day with Eminem (Marshal Bruce Mathers the III - aka Slim Shady) . In a short few months, he became one of the most provocative, outrageous, and obsessive rappers in contemporary music. As Eminem rocks the rap world, the hip hop community greets him with open arms and rock stations and the fans just can't get enough.<br /><br />This is not an artist or record company music release, and sound quality varies due to the nature of recordings. This Eminem audiobiog is a unique and exclusive recording of one of the biggest music success stories of the millennium.<br /><br />Described as sarcastic, offensive, foul mouthed, his cynical outlook on life has struck a chord with millions of rap fans. Every collector, fan and music historian must have this.<br /><br /><b>Explicit Language Warning: You must be 18 years or older to purchase this programme.</b>",
        image: "https://is1-ssl.mzstatic.com/image/thumb/Music6/v4/79/33/e9/7933e93b-0354-9c10-6c7a-c280552d390c/mzi.imndwlmp.jpg/100x100bb.jpg",
        isStreamable: null,
        kind: null,
        previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview123/v4/ac/2b/54/ac2b5458-02e9-206b-e0f0-cc06f44e59a3/mzaf_5940701668146496946.std.aac.p.m4a",
        primaryGenreName: "Nonfiction",
        trackCount: 1,
        trackId: null,
        trackName: null,
        trackViewUrl: null
    )]
  );
  test('subclass of music entity', ()async{
    expect(testMusicModel, isA<MusicEntity>());
  });

  test('should return a valid model from json', ()async {
    final Map<String,dynamic> jsonMap =jsonDecode(readJson('helpers/dummy_data/dummy_music_data.json'));

    final result = MusicModel.fromJson(jsonMap);
    
    expect(result, equals(testMusicModel));

  });

  test('should return a json map containing proper data',()async{
    final result = testMusicModel.toJson();

    const expectedJsonMap = {
      "resultCount": 1,
      "results": [
        {
          "artistName": "Joe Jacks, Pete Bruen, Michael Hans & Marie Hass",
          "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music6/v4/79/33/e9/7933e93b-0354-9c10-6c7a-c280552d390c/mzi.imndwlmp.jpg/100x100bb.jpg",
          "collectionExplicitness": "notExplicit",
          "trackCount": 1,
          "kind":null,
          "trackId":null,
          "copyright": "© 2010 John Brown Rockview",
          "country": "USA",
          "trackName":null,
          "trackViewUrl":null,
          "isStreamable":null,
          "primaryGenreName": "Nonfiction",
          "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview123/v4/ac/2b/54/ac2b5458-02e9-206b-e0f0-cc06f44e59a3/mzaf_5940701668146496946.std.aac.p.m4a",
          "description": "Shock, controversy and pathological rage are the order of the day with Eminem (Marshal Bruce Mathers the III - aka Slim Shady) . In a short few months, he became one of the most provocative, outrageous, and obsessive rappers in contemporary music. As Eminem rocks the rap world, the hip hop community greets him with open arms and rock stations and the fans just can't get enough.<br /><br />This is not an artist or record company music release, and sound quality varies due to the nature of recordings. This Eminem audiobiog is a unique and exclusive recording of one of the biggest music success stories of the millennium.<br /><br />Described as sarcastic, offensive, foul mouthed, his cynical outlook on life has struck a chord with millions of rap fans. Every collector, fan and music historian must have this.<br /><br /><b>Explicit Language Warning: You must be 18 years or older to purchase this programme.</b>"
        }
      ]
    };
    expect(result, equals(expectedJsonMap));
  });
}