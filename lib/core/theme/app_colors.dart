// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class AppColors {
  static final dark = _DarkThemeColors();

  static final light = _LightThemeColors();
}

class _DarkThemeColors {
  final background = const Color(0xFF121212);
  final text = const Color(0xFFF7F7F7);
  final favorite = const Color(0xFFF2C94C);
  final star = const Color(0xFFF7F7F7);
  final title = const Color(0xFFF7F7F7);
  final buttonBackground1 = const Color(0xFFF2C94C);
  final buttonText1 = const Color(0xFF121212);
  final buttonBackground2 = const Color(0xFFF7F7F7);
  final buttonText2 = const Color(0xFFF7F7F7);
  final search = const Color(0xFF121212);
}

class _LightThemeColors {
  final background = const Color(0xFFF7F7F7);
  final text = const Color(0xFF121212);
  final favorite = const Color(0xFFF2C94C);
  final star = const Color(0xFFF7F7F7);
  final title = const Color(0xFFF7F7F7);
  final buttonBackground1 = const Color(0xFFF2C94C);
  final buttonText1 = const Color(0xFF121212);
  final buttonBackground2 = const Color(0xFF121212);
  final buttonText2 = const Color(0xFF121212);
  final search = const Color(0xFFF7F7F7);
}
