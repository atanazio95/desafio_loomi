import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsHeader extends StatefulWidget {
  const NewsHeader({super.key});

  @override
  State<NewsHeader> createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isSearching ? _buildSearchField() : _buildDefaultHeader(),
        ),
      ),
    );
  }

  Widget _buildDefaultHeader() {
    return Row(
      key: const ValueKey('default'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Image.asset(
                  'assets/assets/menu_loomi.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(
              'assets/assets/nortus.png',
              width: 89,
              height: 20,
              fit: BoxFit.contain,
            ),
          ],
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.search, size: 28, color: Color(0xFF0F172A)),
          onPressed: () => setState(() => _isSearching = true),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Row(
      key: const ValueKey('search'),
      children: [
        InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Image.asset(
            'assets/assets/menu_loomi.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF0F172A),
            ),
            cursorColor: const Color(0xFF1876D2),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 16,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1876D2), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              context.read<NewsBloc>().add(SearchNewsEvent(value));
            },
          ),
        ),

        const SizedBox(width: 16),

        GestureDetector(
          onTap: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              context.read<NewsBloc>().add(const SearchNewsEvent(''));
            });
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: const Icon(Icons.close, size: 18, color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
