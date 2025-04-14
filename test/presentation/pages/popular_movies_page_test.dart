import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/event/popular_movies_event.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/state/popular_movies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockBloc.state).thenReturn(PopularMoviesLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    final tMovies = <Movie>[];
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoaded(tMovies)));
    when(mockBloc.state).thenReturn(PopularMoviesLoaded(tMovies));

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesError('Error message')));
    when(mockBloc.state).thenReturn(PopularMoviesError('Error message'));

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    // Assert
    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should dispatch event when page is initialized',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockBloc.state).thenReturn(PopularMoviesLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    // Assert
    verify(mockBloc.add(FetchPopularMoviesBloc())).called(1);
  });
}
