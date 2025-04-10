import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/event/movie_list_event.dart';
import 'package:ditonton/presentation/state/movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingStatus: NowPlayingStatus.loading));

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.loaded,
        nowPlayingMovies: movies,
      )),
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(popularStatus: PopularStatus.loading));

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        popularStatus: PopularStatus.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        popularStatus: PopularStatus.loaded,
        popularMovies: movies,
      )),
    );
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: TopRatedStatus.loading));

    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(state.copyWith(
        topRatedStatus: TopRatedStatus.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        topRatedStatus: TopRatedStatus.loaded,
        topRatedMovies: movies,
      )),
    );
  }
}
