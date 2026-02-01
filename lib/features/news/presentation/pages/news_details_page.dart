import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/details/news_details_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/details/news_details_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/details/news_details_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/related_news_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsDetailsPage extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailsPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsDetailsBloc>()..add(GetNewsDetails(news.id)),
      child: Scaffold(
        body: BlocBuilder<NewsDetailsBloc, NewsDetailsState>(
          builder: (context, state) {
            NewsEntity displayNews = news;
            bool isLoadingRelated = true;

            if (state is NewsDetailsLoaded) {
              displayNews = state.news;
              isLoadingRelated = false;
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  pinned: true,
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'news_image_${displayNews.id}',
                      child: Image.network(
                        displayNews.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[800]),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayNews.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayNews.datePublished.split('T').first,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                displayNews.author,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        Text(
                          displayNews.summary,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is NewsDetailsLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (state is NewsDetailsLoaded &&
                    state.news.relatedNews.isNotEmpty)
                  SliverToBoxAdapter(
                    child: RelatedNewsList(
                      relatedNews: state.news.relatedNews,
                      onTap: (selectedNews) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailsPage(news: selectedNews),
                          ),
                        );
                      },
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }
}
