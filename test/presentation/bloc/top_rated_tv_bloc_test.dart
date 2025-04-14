import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/event/top_rated_tv_event.dart';
import 'package:ditonton/presentation/state/top_rated_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvBloc bloc;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvBloc(mockGetTopRatedTvSeries);
  });

  tearDown(() {
    bloc.close();
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

  test('initial state should be empty', () {
    expect(bloc.state, TopRatedTvInitial());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvEvent()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvLoaded(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvEvent()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}
