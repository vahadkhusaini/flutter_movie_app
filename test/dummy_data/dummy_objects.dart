import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/j5CR0gFPjwgmAXkV9HGaF4VMjIW.jpg',
  genreIds: [10766, 18, 35],
  id: 257064,
  originalLanguage: 'pt',
  originalName: 'Volta por Cima',
  overview: '',
  popularity: 1758.479,
  posterPath: '/nyN8R0P1Hqwq7ksJz4O2BIAUd4W.jpg',
  firstAirDate: '2024-09-30',
  name: 'Volta por Cima',
  voteAverage: 5.5,
  voteCount: 17,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/9faGSFi5jam6pDWGNd0p8JcJgXQ.jpg',
  genres: [Genre(id: 18, name: 'Drama'), Genre(id: 80, name: 'Crime')],
  id: 1396,
  originalLanguage: 'en',
  originalName: 'Breaking Bad',
  overview:
      "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
  popularity: 194.507,
  posterPath: '/ineLOBPG8AZsluYwnkMpHRyu7L.jpg',
  firstAirDate: '2008-01-20',
  name: 'Breaking Bad',
  voteAverage: 8.924,
  voteCount: 15156,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1396,
  name: 'Breaking Bad',
  posterPath: '/ineLOBPG8AZsluYwnkMpHRyu7L.jpg',
  overview:
      'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his financial future at any cost as he enters the dangerous world of drugs and crime.',
);

final testTvTable = TvTable(
  id: 1396,
  name: 'Breaking Bad',
  posterPath: '/ineLOBPG8AZsluYwnkMpHRyu7L.jpg',
  overview:
      'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his financial future at any cost as he enters the dangerous world of drugs and crime.',
);

final testTvMap = {
  'id': 1396,
  'name': 'Breaking Bad',
  'posterPath': '/ineLOBPG8AZsluYwnkMpHRyu7L.jpg',
  'overview':
      'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his financial future at any cost as he enters the dangerous world of drugs and crime.',
};

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
