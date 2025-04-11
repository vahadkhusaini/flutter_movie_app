import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

enum NowPlayingStatus { initial, loading, loaded, error }

enum PopularStatus { initial, loading, loaded, error }

enum TopRatedStatus { initial, loading, loaded, error }

class TvListState extends Equatable {
  final List<TvSeries> nowPlayingTvSeries;
  final NowPlayingStatus nowPlayingStatus;
  final List<TvSeries> popularTvSeries;
  final PopularStatus popularStatus;
  final List<TvSeries> topRatedTvSeries;
  final TopRatedStatus topRatedStatus;
  final String message;

  const TvListState({
    this.nowPlayingTvSeries = const [],
    this.nowPlayingStatus = NowPlayingStatus.initial,
    this.popularTvSeries = const [],
    this.popularStatus = PopularStatus.initial,
    this.topRatedTvSeries = const [],
    this.topRatedStatus = TopRatedStatus.initial,
    this.message = '',
  });

  TvListState copyWith({
    List<TvSeries>? nowPlayingTvSeries,
    NowPlayingStatus? nowPlayingStatus,
    List<TvSeries>? popularTvSeries,
    PopularStatus? popularStatus,
    List<TvSeries>? topRatedTvSeries,
    TopRatedStatus? topRatedStatus,
    String? message,
  }) {
    return TvListState(
      nowPlayingTvSeries: nowPlayingTvSeries ?? this.nowPlayingTvSeries,
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularStatus: popularStatus ?? this.popularStatus,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingTvSeries,
        nowPlayingStatus,
        popularTvSeries,
        popularStatus,
        topRatedTvSeries,
        topRatedStatus,
        message,
      ];
}
