import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/event/watchlist_tv_event.dart';
import 'package:ditonton/presentation/state/watchlist_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvBloc({required this.getWatchlistTvSeries})
      : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>(_onFetchWatchlistTv);
  }

  Future<void> _onFetchWatchlistTv(
    FetchWatchlistTv event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(WatchlistTvLoading());

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvError(failure.message));
      },
      (tv) {
        emit(WatchlistTvLoaded(tv));
      },
    );
  }
}
