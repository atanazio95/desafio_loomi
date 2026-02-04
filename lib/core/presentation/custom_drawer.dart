import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:desafio_loomi_flutter/features/categories/presentation/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Drawer header with back and title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Notícias',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          // Category list from API
          Expanded(
            flex: 6,
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state.isLoading && state.categories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.loading),
                  );
                }
                if (state.error != null && state.categories.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) => _buildDrawerItem(state.categories[index]),
                );
              },
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: 0,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
