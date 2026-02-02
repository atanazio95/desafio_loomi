import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/profile_header.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/news_card.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const borderColorDefault = Color(0xFF0B1125);
    const borderColorDanger = Color(0xFFF5222D);
    const brandBlue = Color(0xFF1876D2);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.pushReplacement('/login');
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomHomeAppBar(selectedTab: 1, onTabChanged: (index) {}),
        body: Column(
          children: [
            const ProfileHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // --- DADOS DO USUÁRIO (VINDOS DA API) ---
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        // 1. Loading
                        if (state is UserLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        // 2. Erro
                        if (state is UserError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar perfil',
                              style: GoogleFonts.inter(color: Colors.red),
                            ),
                          );
                        }

                        // 3. Sucesso (Dados Carregados)
                        if (state is UserLoaded) {
                          final user = state.user;

                          // Formata o endereço (Cidade, Estado)
                          final addressText = user.address != null
                              ? '${user.address!.city}, ${user.address!.state}'
                              : 'Localização não informada';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // NOME
                              Text(
                                user.name,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // EMAIL
                              Text(
                                user.email,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // LOCALIZAÇÃO
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    addressText,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        // Estado Inicial (vazio ou placeholder)
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 48),

                    // --- BOTÕES DE AÇÃO ---
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        // [ATUALIZAÇÃO IMPORTANTE AQUI]
                        onPressed: () async {
                          final userBloc = context.read<UserBloc>();

                          // Aguarda o retorno da tela de edição
                          // Passamos o bloc via extra para manter a injeção
                          final result = await context.push<bool>(
                            '/edit-profile',
                            extra: userBloc,
                          );

                          // Se result for true, significa que o usuário salvou com sucesso.
                          // Disparamos o evento para recarregar a tela.
                          if (result == true) {
                            userBloc.add(GetUserProfile());
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: borderColorDefault,
                            width: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                        child: Text(
                          'Configurações de usuário',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: borderColorDefault,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: borderColorDanger,
                            width: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                        ),
                        child: Text(
                          'Sair da conta',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: borderColorDanger,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // --- ABA FAVORITOS ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Noticias favoritadas',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: brandBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 116,
                          height: 3,
                          decoration: BoxDecoration(
                            color: brandBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- LISTA DE FAVORITOS (BlocBuilder) ---
                    BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
                        // 2. Lista Vazia
                        if (state.savedNews.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32.0,
                              ),
                              child: Text(
                                'Você ainda não favoritou nenhuma notícia.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }

                        // 3. Sucesso
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.savedNews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final news = state.savedNews[index];

                            return NewsCard(
                              news: news,
                              onFavoriteToggle: () {
                                // Lógica de toggle
                              },
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
