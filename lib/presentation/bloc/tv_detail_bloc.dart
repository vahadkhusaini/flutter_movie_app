import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/event/tv_detail_event.dart';
import 'package:ditonton/presentation/state/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvStatus getWatchlistTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(state.copyWith(tvState: RequestState.Loading));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          tvState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvSeriesDetail) async {
        emit(state.copyWith(
          tv: tvSeriesDetail,
          tvState: RequestState.Loaded,
        ));

        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (recommendations) {
            emit(state.copyWith(
              recommendations: recommendations,
              recommendationState: RequestState.Loaded,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await saveWatchlistTv.execute(event.tv);
    final isInWatchlist = await getWatchlistTvStatus.execute(event.tv.id);

    result.fold(
      (failure) {
        emit(state.copyWith(
          watchlistMessage: failure.message,
          isAddedToWatchlist: isInWatchlist,
        ));
      },
      (successMessage) {
        emit(state.copyWith(
          watchlistMessage: successMessage,
          isAddedToWatchlist: isInWatchlist,
        ));
      },
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await removeWatchlistTv.execute(event.tv);
    final isInWatchlist = await getWatchlistTvStatus.execute(event.tv.id);

    result.fold(
      (failure) {
        emit(state.copyWith(
          watchlistMessage: failure.message,
          isAddedToWatchlist: isInWatchlist,
        ));
      },
      (successMessage) {
        emit(state.copyWith(
          watchlistMessage: successMessage,
          isAddedToWatchlist: isInWatchlist,
        ));
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await getWatchlistTvStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
