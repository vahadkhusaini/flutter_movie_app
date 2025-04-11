import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvDetailEvent {
  final TvSeriesDetail tv;

  const AddToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvSeriesDetail tv;

  const RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
