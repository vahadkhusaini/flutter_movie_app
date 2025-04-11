import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton/presentation/event/tv_list_event.dart';
import 'package:ditonton/presentation/state/tv_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvListBloc tvListBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvListBloc = TvListBloc(
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  tearDown(() {
    tvListBloc.close();
  });

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
  final tTvList = <TvSeries>[tTv];

  group('now playing movies', () {
    test('initial state should be empty', () {
      expect(tvListBloc.state, TvListState());
    });

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTv()),
      expect: () => [
        TvListState(nowPlayingStatus: NowPlayingStatus.loading),
        TvListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingTvSeries: tTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when get now playing movies is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTv()),
      expect: () => [
        TvListState(nowPlayingStatus: NowPlayingStatus.loading),
        TvListState(
          nowPlayingStatus: NowPlayingStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );
  });

  group('popular movies', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        TvListState(popularStatus: PopularStatus.loading),
        TvListState(
          popularStatus: PopularStatus.loaded,
          popularTvSeries: tTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when get popular movies is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        TvListState(popularStatus: PopularStatus.loading),
        TvListState(
          popularStatus: PopularStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );
  });

  group('top rated movies', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TvListState(topRatedStatus: TopRatedStatus.loading),
        TvListState(
          topRatedStatus: TopRatedStatus.loaded,
          topRatedTvSeries: tTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when get top rated movies is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TvListState(topRatedStatus: TopRatedStatus.loading),
        TvListState(
          topRatedStatus: TopRatedStatus.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );
  });

  // Test case for multiple operations
  group('multiple operations', () {
    blocTest<TvListBloc, TvListState>(
      'should maintain previous state while updating specific part of state',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBloc;
      },
      act: (bloc) async {
        bloc.add(FetchNowPlayingTv());
        await Future.delayed(Duration(milliseconds: 100));
        bloc.add(FetchPopularTv());
      },
      expect: () => [
        // First operation changes nowPlayingStatus
        TvListState(nowPlayingStatus: NowPlayingStatus.loading),
        TvListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingTvSeries: tTvList,
        ),
        // Second operation changes popularStatus while maintaining nowPlaying state
        TvListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingTvSeries: tTvList,
          popularStatus: PopularStatus.loading,
        ),
        TvListState(
          nowPlayingStatus: NowPlayingStatus.loaded,
          nowPlayingTvSeries: tTvList,
          popularStatus: PopularStatus.loaded,
          popularTvSeries: tTvList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
        verify(mockGetPopularTvSeries.execute());
      },
    );
  });
}
