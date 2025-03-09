import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvSeriesModel(
    adult: false,
    firstAirDate: '2024-09-30',
    backdropPath: '/j5CR0gFPjwgmAXkV9HGaF4VMjIW.jpg',
    genreIds: [10766, 18, 35],
    id: 257064,
    originalName: 'Volta por Cima',
    overview: '',
    popularity: 1758.479,
    posterPath: '/nyN8R0P1Hqwq7ksJz4O2BIAUd4W.jpg',
    originalLanguage: 'pt',
    name: 'Volta por Cima',
    voteAverage: 5.5,
    voteCount: 17,
  );
  final tTvResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "first_air_date": '2024-09-30',
            "backdrop_path": '/j5CR0gFPjwgmAXkV9HGaF4VMjIW.jpg',
            "genre_ids": [10766, 18, 35],
            "id": 257064,
            "original_language": 'pt',
            "original_name": 'Volta por Cima',
            "overview": '',
            "popularity": 1758.479,
            "poster_path": '/nyN8R0P1Hqwq7ksJz4O2BIAUd4W.jpg',
            "name": 'Volta por Cima',
            "vote_average": 5.5,
            "vote_count": 17,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
