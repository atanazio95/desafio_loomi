import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          // Título da Seção (Opcional, se quiser manter o estilo das mensagens anteriores)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Nortus',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // --- CAMPO DE BUSCA ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar notícias...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                // context.read<NewsBloc>().add(NewsSearchChanged(value));
              },
            ),
          ),

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
