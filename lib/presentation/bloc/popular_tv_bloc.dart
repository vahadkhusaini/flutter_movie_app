import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/event/popular_tv_event.dart';
import 'package:ditonton/presentation/state/popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvBloc(this.getPopularTvSeries) : super(PopularTvInitial()) {
    on<FetchPopularTvBloc>((event, emit) async {
      emit(PopularTvLoading());
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (tv) => emit(PopularTvLoaded(tv)),
      );
    });
  }
}
