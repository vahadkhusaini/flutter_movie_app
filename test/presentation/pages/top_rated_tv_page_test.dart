import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/event/top_rated_tv_event.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/state/top_rated_tv_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_page_test.mocks.dart';

@GenerateMocks([TopRatedTvBloc])
void main() {
  late MockTopRatedTvBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(mockBloc.state).thenReturn(TopRatedTvLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    // Assert
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    // Arrange
    final tTvList = <TvSeries>[];

    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvLoaded(tTvList)));
    when(mockBloc.state).thenReturn(TopRatedTvLoaded(tTvList));

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    // Assert
    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvError('Error message')));
    when(mockBloc.state).thenReturn(TopRatedTvError('Error message'));

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    // Assert
    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Should dispatch event when page is initialized',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(mockBloc.state).thenReturn(TopRatedTvLoading());

    // Act
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    // Assert
    verify(mockBloc.add(FetchTopRatedTvEvent())).called(1);
  });
}
