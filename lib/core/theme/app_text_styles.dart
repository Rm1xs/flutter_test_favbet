// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final dark = _DarkTextStyles();

  static final light = _LightTextStyles();
}

class _DarkTextStyles {
  TextStyle get headline => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.dark.title,
  );

  TextStyle get body => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.dark.text,
  );

  TextStyle get button => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.dark.buttonText1,
  );

  TextStyle get caption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    // ignore: deprecated_member_use
    color: AppColors.dark.text.withOpacity(0.7),
  );
}

class _LightTextStyles {
  TextStyle get headline => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.light.title,
  );

  TextStyle get body => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.light.text,
  );

  TextStyle get button => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.light.buttonText1,
  );

  TextStyle get caption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    // ignore: deprecated_member_use
    color: AppColors.light.text.withOpacity(0.7),
  );
}
