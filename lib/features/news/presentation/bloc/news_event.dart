import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class NewsFetched extends NewsEvent {}

class ToggleFavoriteHome extends NewsEvent {
  final String id;
  ToggleFavoriteHome(this.id);
}

class GetSavedNews extends NewsEvent {}

class RefreshFavorites extends NewsEvent {}
