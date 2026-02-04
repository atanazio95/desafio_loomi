import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/profile_header.dart';
import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/news_card.dart';
import 'package:desafio_loomi_flutter/features/profile/presentation/widgets/section_title.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    if (userBloc.state is! UserLoaded) {
      userBloc.add(GetUserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.pushReplacement('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceWhite,
        appBar: CustomHomeAppBar(selectedTab: 1, onTabChanged: (index) {}),
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 40),

                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: AppColors.loading,
                              ),
                            ),
                          );
                        }

                        if (state is UserError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar perfil',
                              style: GoogleFonts.inter(color: AppColors.error),
                            ),
                          );
                        }

                        if (state is UserLoaded) {
                          final user = state.user;
                          final addressText = user.address != null
                              ? '${user.address!.city}, ${user.address!.state}'
                              : 'Localização não informada';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user.email,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    addressText,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 48),

                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push('/edit-profile'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.textPrimary,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<AuthBloc>().add(LogoutRequested()),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.error,
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
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    SectionTitle(
                      title: 'Noticias favoritadas',
                      accentColor: AppColors.primary,
                    ),

                    const SizedBox(height: 24),

                    // Favorites section
                    BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
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
                                  color: AppColors.labelHint,
                                ),
                              ),
                            ),
                          );
                        }

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
                                context.read<NewsBloc>().add(
                                  ToggleFavoriteHome(news.id),
                                );
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
      ),
    );
  }
}
