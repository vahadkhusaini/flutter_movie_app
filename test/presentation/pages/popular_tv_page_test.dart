import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/event/popular_tv_event.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/state/popular_tv_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_page_test.mocks.dart';

@GenerateMocks([PopularTvBloc])
void main() {
  late MockPopularTvBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(mockBloc.state).thenReturn(PopularTvLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    // Assert
    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    final tTvList = <TvSeries>[];
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoaded(tTvList)));
    when(mockBloc.state).thenReturn(PopularTvLoaded(tTvList));

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvError('Error message')));
    when(mockBloc.state).thenReturn(PopularTvError('Error message'));

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    // Assert
    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should dispatch event when page is initialized',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(mockBloc.state).thenReturn(PopularTvLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    // Assert
    verify(mockBloc.add(FetchPopularTvBloc())).called(1);
  });
}
