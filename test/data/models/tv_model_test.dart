import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvSeriesModel(
    adult: false,
    firstAirDate: '2023-08-23',
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

  final tTv = TvSeries(
    adult: false,
    firstAirDate: '2023-08-23',
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

  test('should be a subclass of TV entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
