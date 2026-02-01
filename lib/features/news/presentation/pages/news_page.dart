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
  final _searchController = TextEditingController(); // Novo: Controle da busca

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Dispara o fetch inicial
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
      appBar: AppBar(
        title: const Text('Loomi News'),
        centerTitle: true,
        // Adicionando botão para ir ao perfil (requisito do PDF)
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => context.push('/profile'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 1. DISPARA O EVENTO (Isso vai limpar o SharedPreferences e o Estado)
              context.read<AuthBloc>().add(LogoutRequested());

              // 2. NAVEGA (Opcional se você tiver um Listener global, mas pode manter aqui)
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- CAMPO DE BUSCA (Requisito do PDF) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                // Aqui você pode disparar um evento de busca no seu Bloc
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
