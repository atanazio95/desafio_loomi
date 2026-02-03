import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final padH = Responsive.horizontalPadding(context);
    final logoW = Responsive.logoWidth(context);
    final logoH = Responsive.logoHeight(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Image.asset(
                'assets/assets/nortus.png',
                width: logoW,
                height: logoH,
                fit: BoxFit.contain,
              ),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.search, size: 28, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
