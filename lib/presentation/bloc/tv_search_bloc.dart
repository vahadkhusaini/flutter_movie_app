import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/event/search_event.dart';
import 'package:ditonton/presentation/state/tv_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TvSearchBloc extends Bloc<SearchEvent, TvSearchState> {
  final SearchTvSeries _searchTvSeries;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  TvSearchBloc(this._searchTvSeries) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (data) {
          emit(SearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
