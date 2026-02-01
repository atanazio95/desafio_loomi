import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String author;
  final String title;
  final String summary;
  final String imageUrl;
  final String datePublished;
  final List<NewsEntity> relatedNews;

  const NewsEntity({
    required this.id,
    required this.author,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.datePublished,
    this.relatedNews = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    summary,
    datePublished,
    imageUrl,
    relatedNews,
  ];
}
