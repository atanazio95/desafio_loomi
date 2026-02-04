import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetNewsEvent extends NewsEvent {
  final int page;

  const GetNewsEvent({required this.page});

  @override
  List<Object> get props => [page];
}

class ToggleFavoriteHome extends NewsEvent {
  final String id;

  const ToggleFavoriteHome(this.id);

  @override
  List<Object> get props => [id];
}

class SearchNewsEvent extends NewsEvent {
  final String query;
  const SearchNewsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadNewsDetailsEvent extends NewsEvent {
  final String id;

  const LoadNewsDetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
