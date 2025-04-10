import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/event/movie_list_event.dart';
import 'package:ditonton/presentation/state/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() {
    movieListBloc.close();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('now playing movies', () {
    test('initial state should be empty', () {
      expect(movieListBloc.state, MovieListState());
    });

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState(nowPlayingStatus: NowPlayingStatus.loading),
        MovieListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingMovies: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when get now playing movies is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState(nowPlayingStatus: NowPlayingStatus.loading),
        MovieListState(
          nowPlayingStatus: NowPlayingStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('popular movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState(popularStatus: PopularStatus.loading),
        MovieListState(
          popularStatus: PopularStatus.loaded,
          popularMovies: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when get popular movies is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState(popularStatus: PopularStatus.loading),
        MovieListState(
          popularStatus: PopularStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('top rated movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState(topRatedStatus: TopRatedStatus.loading),
        MovieListState(
          topRatedStatus: TopRatedStatus.loaded,
          topRatedMovies: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when get top rated movies is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState(topRatedStatus: TopRatedStatus.loading),
        MovieListState(
          topRatedStatus: TopRatedStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });

  // Test case for multiple operations
  group('multiple operations', () {
    blocTest<MovieListBloc, MovieListState>(
      'should maintain previous state while updating specific part of state',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) async {
        bloc.add(FetchNowPlayingMovies());
        await Future.delayed(Duration(milliseconds: 100));
        bloc.add(FetchPopularMovies());
      },
      expect: () => [
        // First operation changes nowPlayingStatus
        MovieListState(nowPlayingStatus: NowPlayingStatus.loading),
        MovieListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingMovies: tMovieList,
        ),
        // Second operation changes popularStatus while maintaining nowPlaying state
        MovieListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingMovies: tMovieList,
          popularStatus: PopularStatus.loading,
        ),
        MovieListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingMovies: tMovieList,
          popularStatus: PopularStatus.loaded,
          popularMovies: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
