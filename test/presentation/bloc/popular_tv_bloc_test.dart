import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/event/popular_tv_event.dart';
import 'package:ditonton/presentation/state/popular_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvBloc bloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvBloc(mockGetPopularTvSeries);
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

  test('initial state should be PopularTvInitial', () {
    expect(bloc.state, PopularTvInitial());
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvBloc()),
    expect: () => [
      PopularTvLoading(),
      PopularTvLoaded(tTvList),
    ],
    verify: (_) {
      verify(mockGetPopularTvSeries.execute());
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, Error] when get popular tv fails',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvBloc()),
    expect: () => [
      PopularTvLoading(),
      PopularTvError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularTvSeries.execute());
    },
  );
}
