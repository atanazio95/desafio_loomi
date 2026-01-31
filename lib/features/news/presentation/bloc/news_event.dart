import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

// A UI só grita: "Traz notícia!"
class NewsFetched extends NewsEvent {}
