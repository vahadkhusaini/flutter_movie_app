abstract class TvListEvent {
  const TvListEvent();
}

class FetchNowPlayingTv extends TvListEvent {}

class FetchPopularTv extends TvListEvent {}

class FetchTopRatedTv extends TvListEvent {}
