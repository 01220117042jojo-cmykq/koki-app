import 'dart:ui';

abstract class ColorManager {
  static Color primary = const Color(0xFF0D2575);
  static Color lessPrimary = const Color(0xFF002F87);
  static Color primaryBackground = primary.withValues(alpha: 0.012);
  static const Color sectionBackground = Color(0xFFECEFF5);

  static Color primaryDark = const Color(0xFF0D2575);
  static Color lightGrey = const Color(0xFFD3D3D3);

  static Color darkSlate = const Color(0xFF1F2937);
  static Color darkRed = const Color(0xFFB9000F);
  static Color coolGray = const Color(0xFF6B7280);
  static Color navy = const Color(0xFF0F2E7E);
  static const Color red = Color(0xFFBB2025);

  static Color darkGrey = const Color(0xff525252);

  static Color whiteGrey = const Color(0xFFF5F5F5);
  static Color white = const Color(0xffffffff);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFC2C2C2);
}
