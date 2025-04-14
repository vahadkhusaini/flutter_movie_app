import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/event/top_rated_tv_event.dart';
import 'package:ditonton/presentation/state/top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvBloc(this.getTopRatedTvSeries) : super(TopRatedTvInitial()) {
    on<FetchTopRatedTvEvent>((event, emit) async {
      emit(TopRatedTvLoading());

      final result = await getTopRatedTvSeries.execute();

      result.fold(
        (failure) => emit(TopRatedTvError(failure.message)),
        (movies) => emit(TopRatedTvLoaded(movies)),
      );
    });
  }
}
