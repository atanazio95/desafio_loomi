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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Dispara a busca inicial assim que a tela abre
    context.read<NewsBloc>().add(NewsFetched());
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    // Se chegou a 90% da tela, carrega mais
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loomi News'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout simples para testar (Em produção chamaria o AuthBloc)
              context.go('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          switch (state.status) {
            case NewsStatus.failure:
              return const Center(
                child: Text('Erro ao carregar notícias. Tente novamente.'),
              );

            case NewsStatus.success:
              if (state.news.isEmpty) {
                return const Center(child: Text('Nenhuma notícia encontrada.'));
              }
              return ListView.builder(
                controller: _scrollController,
                // Se não acabou a lista, adicionamos +1 item (que é o loading do rodapé)
                itemCount: state.hasReachedMax
                    ? state.news.length
                    : state.news.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  // Se o índice for maior que a lista, desenha o Loader
                  if (index >= state.news.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Senão, desenha o Card da notícia
                  return NewsCard(news: state.news[index]);
                },
              );

            case NewsStatus.initial:
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
