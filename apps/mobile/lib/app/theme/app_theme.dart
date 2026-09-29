import 'package:flutter/material.dart';

/// HALO's look, taken from the brand material (`apps/web/public`): pale,
/// luminous gold light, a thin halo ring, and a didone wordmark. Playfair
/// Display sets titles; Inter (the web's body face) sets everything else.
abstract final class AppTheme {
  static const radius = 12.0;

  /// Printed-cover corners: covers read as objects, not UI cards.
  static const coverRadius = 4.0;

  static ThemeData get light => _build(
        const ColorScheme(
          brightness: Brightness.light,
          surface: Color(0xFFFFFDF6), // paper
          onSurface: Color(0xFF221E17), // ink
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFFBF7EA),
          surfaceContainer: Color(0xFFF7F1DF),
          surfaceContainerHigh: Color(0xFFF2EBD4),
          surfaceContainerHighest: Color(0xFFECE3C8),
          onSurfaceVariant: Color(0xFF6E6656),
          primary: Color(0xFF86641D), // deep gold, 5.3:1 on paper
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFF3E3A0), // halo gold
          onPrimaryContainer: Color(0xFF3A2C08),
          secondary: Color(0xFF6E6656),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF2EBD4),
          onSecondaryContainer: Color(0xFF221E17),
          outline: Color(0xFFD9CFB2),
          outlineVariant: Color(0xFFE8DFC6),
          error: Color(0xFFB3261E),
          onError: Color(0xFFFFFFFF),
        ),
        const HaloColors(glow: Color(0xFFF3E3A0), ring: Color(0xFFD9B95A)),
      );

  static ThemeData get dark => _build(
        const ColorScheme(
          brightness: Brightness.dark,
          surface: Color(0xFF15130F), // warm night
          onSurface: Color(0xFFF4EEDF),
          surfaceContainerLowest: Color(0xFF100E0B),
          surfaceContainerLow: Color(0xFF1B1813),
          surfaceContainer: Color(0xFF211D17),
          surfaceContainerHigh: Color(0xFF2A251D),
          surfaceContainerHighest: Color(0xFF342E24),
          onSurfaceVariant: Color(0xFFBDB29A),
          primary: Color(0xFFE8C766), // the light source
          onPrimary: Color(0xFF2A2006),
          primaryContainer: Color(0xFF4A3A10),
          onPrimaryContainer: Color(0xFFF7E7B0),
          secondary: Color(0xFFBDB29A),
          onSecondary: Color(0xFF221E17),
          secondaryContainer: Color(0xFF2A251D),
          onSecondaryContainer: Color(0xFFF4EEDF),
          outline: Color(0xFF4A4336),
          outlineVariant: Color(0xFF332D24),
          error: Color(0xFFF2B8B5),
          onError: Color(0xFF601410),
        ),
        const HaloColors(glow: Color(0xFF5C4712), ring: Color(0xFFE8C766)),
      );

  static ThemeData _build(ColorScheme scheme, HaloColors halo) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: color, width: width),
        );

    final text = _textTheme(scheme.onSurface);

    return ThemeData(
      colorScheme: scheme,
      fontFamily: _sans,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [halo],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium!.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: border(scheme.outline),
        enabledBorder: border(scheme.outline),
        focusedBorder: border(scheme.primary, 1.5),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: shape,
          minimumSize: const Size.fromHeight(48),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: shape,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: scheme.outline),
          foregroundColor: scheme.onSurface,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: text.labelLarge),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outline),
        backgroundColor: scheme.surface,
        selectedColor: scheme.primaryContainer,
        labelStyle: text.labelLarge,
        showCheckmark: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: shape.copyWith(side: BorderSide(color: scheme.outlineVariant)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.bodyLarge,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: scheme.surface),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    );
  }

  static const _serif = 'PlayfairDisplay';
  static const _sans = 'Inter';

  /// Variable fonts: set the `wght` axis alongside `fontWeight`.
  static TextStyle _style(
    String family,
    double size,
    FontWeight weight, {
    double height = 1.4,
    double letterSpacing = 0,
    required Color color,
  }) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight,
        fontVariations: [FontVariation.weight(weight.value.toDouble())],
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextTheme _textTheme(Color ink) => TextTheme(
        // Titles: Playfair Display, like the wordmark.
        displaySmall: _style(_serif, 36, FontWeight.w600, height: 1.15, color: ink),
        headlineMedium: _style(_serif, 28, FontWeight.w600, height: 1.2, color: ink),
        headlineSmall: _style(_serif, 24, FontWeight.w600, height: 1.25, color: ink),
        titleLarge: _style(_serif, 21, FontWeight.w600, height: 1.3, color: ink),
        // Everything else: Inter.
        titleMedium: _style(_sans, 16, FontWeight.w600, height: 1.35, color: ink),
        titleSmall: _style(_sans, 14, FontWeight.w600, color: ink),
        bodyLarge: _style(_sans, 16, FontWeight.w400, height: 1.55, color: ink),
        bodyMedium: _style(_sans, 14, FontWeight.w400, height: 1.5, color: ink),
        bodySmall: _style(_sans, 12.5, FontWeight.w400, height: 1.45, color: ink),
        labelLarge: _style(_sans, 14, FontWeight.w600, color: ink),
        labelMedium: _style(_sans, 12, FontWeight.w500, color: ink),
        labelSmall: _style(_sans, 11, FontWeight.w500, color: ink),
      );
}

/// Brand colors Material has no slot for: the halo's glow and ring.
@immutable
class HaloColors extends ThemeExtension<HaloColors> {
  const HaloColors({required this.glow, required this.ring});

  final Color glow;
  final Color ring;

  /// Falls back to the light palette outside [AppTheme] (e.g. widget tests).
  static HaloColors of(BuildContext context) =>
      Theme.of(context).extension<HaloColors>() ??
      const HaloColors(glow: Color(0xFFF3E3A0), ring: Color(0xFFD9B95A));

  @override
  HaloColors copyWith({Color? glow, Color? ring}) =>
      HaloColors(glow: glow ?? this.glow, ring: ring ?? this.ring);

  @override
  HaloColors lerp(HaloColors? other, double t) => other == null
      ? this
      : HaloColors(
          glow: Color.lerp(glow, other.glow, t)!,
          ring: Color.lerp(ring, other.ring, t)!,
        );
}
