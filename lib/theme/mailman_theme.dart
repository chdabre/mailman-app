import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final mailmanTheme = ThemeData.from(
  colorScheme: _mailmanColorScheme,
  textTheme: _mailmanTextTheme,
).copyWith(cardTheme: const CardTheme());

final ColorScheme _mailmanColorScheme = ColorScheme.light(
  primary: const Color(0xFFEABA0F),
  background: const Color(0xFFFDFDFD),
  surface: const Color(0xFFFDFDFD),
  error: const Color(0xFFDE440C),
  onPrimary: Colors.black.withOpacity(0.87),
  onBackground: Colors.white.withOpacity(0.87),
  onSurface: Colors.black.withOpacity(0.87),
  onError: Colors.white.withOpacity(0.87),
  brightness: Brightness.light,
);

final _primaryTheme = GoogleFonts.rubikTextTheme();
final TextTheme _mailmanTextTheme = _primaryTheme.copyWith(
  headline6: _primaryTheme.headline6!.copyWith(
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: _mailmanColorScheme.onSurface,
  ),
  headline4: GoogleFonts.fugazOne(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: _mailmanColorScheme.onSurface,
  ),
  button: _primaryTheme.button!.copyWith(
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
  ),
  overline: _primaryTheme.overline!.copyWith(
    fontWeight: FontWeight.w900,
  ),
);