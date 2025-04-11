import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends TvSearchState {}

class SearchLoading extends TvSearchState {}

class SearchError extends TvSearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends TvSearchState {
  final List<TvSeries> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
