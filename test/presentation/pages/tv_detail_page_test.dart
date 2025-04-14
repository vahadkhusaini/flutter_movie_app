import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/event/tv_detail_event.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/state/tv_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailBloc])
void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    // Act
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.add);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: true,
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: true,
      ),
    );

    // Act
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.check);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    // Initial state
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    // Build the widget
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    // Change the state after tapping
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: true,
            watchlistMessage: 'Added to Watchlist',
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      ),
    );

    // Find watchlist button and tap it
    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    // Trigger the event handler
    verify(mockBloc.add(AddToWatchlist(testTvSeriesDetail)));

    // Update the UI
    await tester.pump();

    // Verify Snackbar appears with correct message
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    // Initial state
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    // Build the widget
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    // Change the state after tapping to simulate failure
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tv: testTvSeriesDetail,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <TvSeries>[],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tv: testTvSeriesDetail,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
    );

    // Find watchlist button and tap it
    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    // Trigger the event handler
    verify(mockBloc.add(AddToWatchlist(testTvSeriesDetail)));

    // Update the UI
    await tester.pump();

    // Verify AlertDialog appears with correct message
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Should dispatch events when initialized',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          TvDetailState(
            tvState: RequestState.Loading,
          ),
        ));
    when(mockBloc.state).thenReturn(
      TvDetailState(
        tvState: RequestState.Loading,
      ),
    );

    // Act
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    // Assert
    verify(mockBloc.add(FetchTvDetail(1))).called(1);
    verify(mockBloc.add(LoadWatchlistStatus(1))).called(1);
  });
}
