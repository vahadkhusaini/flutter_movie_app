import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

enum RequestState { Empty, Loading, Loaded, Error }

class TvDetailState extends Equatable {
  final TvSeriesDetail? tv;
  final List<TvSeries> recommendations;
  final RequestState tvState;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailState({
    this.tv,
    this.recommendations = const [],
    this.tvState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    TvSeriesDetail? tv,
    List<TvSeries>? recommendations,
    RequestState? tvState,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tv: tv ?? this.tv,
      recommendations: recommendations ?? this.recommendations,
      tvState: tvState ?? this.tvState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tv,
        recommendations,
        tvState,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}
