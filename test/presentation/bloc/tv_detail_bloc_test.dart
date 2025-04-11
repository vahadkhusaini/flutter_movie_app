import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/event/tv_detail_event.dart';
import 'package:ditonton/presentation/state/tv_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistTvStatus = MockGetWatchListTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();

    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistTvStatus: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;
  final tTv = testTvSeriesDetail;
  final tTvs = [testTvSeries];

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        TvDetailState(
          tv: testTvSeriesDetail,
          tvState: RequestState.Loaded,
        ),
        TvDetailState(
          tv: testTvSeriesDetail,
          tvState: RequestState.Loaded,
          recommendations: tTvs,
          recommendationState: RequestState.Loaded,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit Error when getMovieDetail fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        const TvDetailState(
          tvState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit Error for recommendations if it fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(tvState: RequestState.Loading),
        TvDetailState(
          tv: testTvSeriesDetail,
          tvState: RequestState.Loaded,
        ),
        TvDetailState(
          tv: testTvSeriesDetail,
          tvState: RequestState.Loaded,
          recommendationState: RequestState.Error,
          message: 'Fail',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit updated state when AddToWatchlist is called',
      build: () {
        when(mockSaveWatchlistTv.execute(tTv))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistTvStatus.execute(tTv.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(tTv)),
      expect: () => [
        const TvDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit updated state when RemoveFromWatchlist is called',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTv))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchlistTvStatus.execute(tTv.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(tTv)),
      expect: () => [
        const TvDetailState(
          watchlistMessage: 'Removed',
          isAddedToWatchlist: false,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should load watchlist status correctly',
      build: () {
        when(mockGetWatchlistTvStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const TvDetailState(isAddedToWatchlist: true),
      ],
    );
  });
}
