// ignore_for_file: avoid_print
//
// Gera assets/app_icon.png: logo com fundo preto trocado por azul (#1876D2).
// Mantém o restante da imagem como está (sem adicionar branco).
// Execute na raiz do projeto: dart run tool/generate_app_icon.dart
// Depois: dart run flutter_launcher_icons
//

import 'dart:io';

import 'package:image/image.dart' as img;

const int size = 1024;
const int logoInset = 102; // padding ~10%
const int blueR = 0x18, blueG = 0x76, blueB = 0xD2;
const int blackThreshold = 40;

void main() {
  final projectRoot = Directory.current;
  final logoPath = projectRoot.uri.resolve('assets/assets/logo_shield.png').toFilePath();
  final outPath = projectRoot.uri.resolve('assets/app_icon.png').toFilePath();

  final logoFile = File(logoPath);
  if (!logoFile.existsSync()) {
    print('ERRO: Não encontrado $logoPath');
    exit(1);
  }

  final bytes = logoFile.readAsBytesSync();
  final logo = img.decodeImage(bytes);
  if (logo == null) {
    print('ERRO: Não foi possível decodificar a imagem do logo.');
    exit(1);
  }

  final logoSize = size - (logoInset * 2);
  final scaled = img.copyResize(logo, width: logoSize, height: logoSize);
  final bg = img.Image(width: size, height: size);
  bg.clear(img.ColorRgb8(blueR, blueG, blueB));

  final ox = logoInset;
  final oy = logoInset;
  for (var y = 0; y < scaled.height; y++) {
    for (var x = 0; x < scaled.width; x++) {
      final p = scaled.getPixel(x, y);
      final r = p.r.toInt();
      final g = p.g.toInt();
      final b = p.b.toInt();
      final isBackground = r <= blackThreshold && g <= blackThreshold && b <= blackThreshold;
      if (isBackground) {
        bg.setPixel(ox + x, oy + y, img.ColorRgb8(blueR, blueG, blueB));
      } else {
        bg.setPixel(ox + x, oy + y, img.ColorRgb8(r, g, b));
      }
    }
  }

  final outFile = File(outPath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(img.encodePng(bg));
  print('Ícone gerado: $outPath');
  print('Próximo passo: dart run flutter_launcher_icons');
}
