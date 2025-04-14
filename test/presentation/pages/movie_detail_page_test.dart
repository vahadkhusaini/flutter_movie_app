import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/event/movie_detail_event.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/state/movie_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    // Act
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.add);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: true,
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: true,
      ),
    );

    // Act
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Assert
    final watchlistButtonIcon = find.byIcon(Icons.check);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    // Initial state
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    // Build the widget
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Change the state after tapping
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: true,
            watchlistMessage: 'Added to Watchlist',
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      ),
    );

    // Find watchlist button and tap it
    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    // Trigger the event handler
    verify(mockBloc.add(AddToWatchlist(testMovieDetail)));

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
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: false,
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    // Build the widget
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // Change the state after tapping to simulate failure
    when(mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            recommendations: <Movie>[],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
        ));
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movie: testMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: <Movie>[],
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
    );

    // Find watchlist button and tap it
    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    // Trigger the event handler
    verify(mockBloc.add(AddToWatchlist(testMovieDetail)));

    // Update the UI
    await tester.pump();

    // Verify AlertDialog appears with correct message
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
