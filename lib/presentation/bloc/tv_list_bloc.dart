import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/event/tv_list_event.dart';
import 'package:ditonton/presentation/state/tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(TvListState()) {
    on<FetchNowPlayingTv>(_onFetchNowPlayingTv);
    on<FetchPopularTv>(_onFetchPopularTv);
    on<FetchTopRatedTv>(_onFetchTopRatedTv);
  }

  Future<void> _onFetchNowPlayingTv(
    FetchNowPlayingTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingStatus: NowPlayingStatus.loading));

    final result = await getNowPlayingTvSeries.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.error,
        message: failure.message,
      )),
      (tv) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.loaded,
        nowPlayingTvSeries: tv,
      )),
    );
  }

  Future<void> _onFetchPopularTv(
    FetchPopularTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(popularStatus: PopularStatus.loading));

    final result = await getPopularTvSeries.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        popularStatus: PopularStatus.error,
        message: failure.message,
      )),
      (tv) => emit(state.copyWith(
        popularStatus: PopularStatus.loaded,
        popularTvSeries: tv,
      )),
    );
  }

  Future<void> _onFetchTopRatedTv(
    FetchTopRatedTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: TopRatedStatus.loading));

    final result = await getTopRatedTvSeries.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        topRatedStatus: TopRatedStatus.error,
        message: failure.message,
      )),
      (tv) => emit(state.copyWith(
        topRatedStatus: TopRatedStatus.loaded,
        topRatedTvSeries: tv,
      )),
    );
  }
}
