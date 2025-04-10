import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

enum NowPlayingStatus { initial, loading, loaded, error }

enum PopularStatus { initial, loading, loaded, error }

enum TopRatedStatus { initial, loading, loaded, error }

class MovieListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final NowPlayingStatus nowPlayingStatus;
  final List<Movie> popularMovies;
  final PopularStatus popularStatus;
  final List<Movie> topRatedMovies;
  final TopRatedStatus topRatedStatus;
  final String message;

  const MovieListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingStatus = NowPlayingStatus.initial,
    this.popularMovies = const [],
    this.popularStatus = PopularStatus.initial,
    this.topRatedMovies = const [],
    this.topRatedStatus = TopRatedStatus.initial,
    this.message = '',
  });

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    NowPlayingStatus? nowPlayingStatus,
    List<Movie>? popularMovies,
    PopularStatus? popularStatus,
    List<Movie>? topRatedMovies,
    TopRatedStatus? topRatedStatus,
    String? message,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      popularStatus: popularStatus ?? this.popularStatus,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingMovies,
        nowPlayingStatus,
        popularMovies,
        popularStatus,
        topRatedMovies,
        topRatedStatus,
        message,
      ];
}
