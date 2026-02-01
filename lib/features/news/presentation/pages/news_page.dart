import 'package:desafio_loomi_flutter/core/presentation/custom_drawer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/header.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NewsBloc>().add(NewsFetched());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NewsBloc>().add(NewsFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: CustomHomeAppBar(
        selectedTab: 0, // 0 pois esta é a aba de Notícias
        onTabChanged: (index) {
          if (index == 1) {
            // Lógica para navegar para o perfil se necessário
            // context.go('/profile');
          }
        },
      ),
      body: Column(
        children: [
          const NewsHeader(),

          // --- LISTAGEM ---
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                switch (state.status) {
                  case NewsStatus.failure:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Erro ao carregar notícias.'),
                          TextButton(
                            onPressed: () =>
                                context.read<NewsBloc>().add(NewsFetched()),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );

                  case NewsStatus.success:
                    if (state.news.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma notícia encontrada.'),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: state.hasReachedMax
                          ? state.news.length
                          : state.news.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.news.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return NewsCard(
                          news: state.news[index],
                          onFavoriteToggle: () {
                            context.read<NewsBloc>().add(
                              ToggleFavoriteHome(state.news[index].id),
                            );
                          },
                        );
                      },
                    );

                  case NewsStatus.initial:
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
