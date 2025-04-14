import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/event/top_rated_movies_event.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/state/top_rated_movies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesLoading()));
    when(mockBloc.state).thenReturn(TopRatedMoviesLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    // Assert
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    final tMovies = <Movie>[];
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesLoaded(tMovies)));
    when(mockBloc.state).thenReturn(TopRatedMoviesLoaded(tMovies));

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesError('Error message')));
    when(mockBloc.state).thenReturn(TopRatedMoviesError('Error message'));

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    // Assert
    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should dispatch event when page is initialized',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesLoading()));
    when(mockBloc.state).thenReturn(TopRatedMoviesLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    // Assert
    verify(mockBloc.add(FetchTopRatedMoviesEvent())).called(1);
  });
}
