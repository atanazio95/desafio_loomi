import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Responsive', () {
    testWidgets('horizontalPadding retorna valor entre 16 e 24 para larguras típicas',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final p = Responsive.horizontalPadding(context);
                expect(p, greaterThanOrEqualTo(16.0));
                expect(p, lessThanOrEqualTo(24.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('horizontalPaddingInsets retorna EdgeInsets simétrico',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(360, 640)),
            child: Builder(
              builder: (context) {
                final insets = Responsive.horizontalPaddingInsets(context);
                expect(insets.left, insets.right);
                expect(insets.left, greaterThanOrEqualTo(16.0));
                expect(insets.left, lessThanOrEqualTo(24.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('imageHeightHero retorna valor limitado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final h = Responsive.imageHeightHero(context);
                expect(h, greaterThan(0));
                expect(h, lessThanOrEqualTo(250.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('imageHeightGrid retorna valor limitado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final h = Responsive.imageHeightGrid(context);
                expect(h, greaterThan(0));
                expect(h, lessThanOrEqualTo(120.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('logoWidth retorna valor entre 70 e 95 para larguras típicas',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final w = Responsive.logoWidth(context);
                expect(w, greaterThanOrEqualTo(70.0));
                expect(w, lessThanOrEqualTo(95.0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('logoHeight é proporcional a logoWidth (89:20)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final w = Responsive.logoWidth(context);
                final h = Responsive.logoHeight(context);
                final expectedRatio = 20.0 / 89.0;
                expect(h / w, closeTo(expectedRatio, 0.01));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
