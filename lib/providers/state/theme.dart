part of '../state.dart';

typedef DynamicColorSeeds = ({
  Color? lightSeed,
  Color? darkSeed,
  Color accentColor,
});

@Riverpod(keepAlive: true)
class DynamicColor extends _$DynamicColor {
  @override
  DynamicColorSeeds build() {
    return (
      lightSeed: null,
      darkSeed: null,
      accentColor: const Color(defaultPrimaryColor),
    );
  }

  void seed({Color? lightSeed, Color? darkSeed, required Color accentColor}) {
    state = (
      lightSeed: lightSeed,
      darkSeed: darkSeed,
      accentColor: accentColor,
    );
  }
}

@riverpod
ColorScheme genColorScheme(
  Ref ref,
  Brightness brightness, {
  Color? color,
  bool ignoreConfig = false,
}) {
  final themeSetting = ref.watch(
    themeSettingProvider.select(
      (state) => (
        primaryColor: state.primaryColor,
        schemeVariant: state.schemeVariant,
      ),
    ),
  );
  ColorScheme scheme;
  if (color == null &&
      (ignoreConfig == true || themeSetting.primaryColor == null)) {
    final seed = switch (brightness) {
      Brightness.light => dynamicColor.lightSeed,
      Brightness.dark => dynamicColor.darkSeed,
    };
    scheme = ColorScheme.fromSeed(
      seedColor: seed ?? dynamicColor.accentColor,
      brightness: brightness,
      dynamicSchemeVariant: themeSetting.schemeVariant,
    );
  } else {
    scheme = ColorScheme.fromSeed(
      seedColor: color ?? Color(themeSetting.primaryColor!),
      brightness: brightness,
      dynamicSchemeVariant: themeSetting.schemeVariant,
    );
  }
  if (brightness == Brightness.dark) {
    return scheme.copyWith(
      surface: const Color(0xFF101515),
      surfaceContainer: const Color(0xFF171E1D),
      surfaceContainerHigh: const Color(0xFF1D2624),
      surfaceContainerHighest: const Color(0xFF222D2B),
      outline: const Color(0xFF2A3632),
      outlineVariant: const Color(0xFF203E32),
      primary: const Color(0xFF7CE3BE),
      onPrimary: const Color(0xFF123629),
      primaryContainer: const Color(0xFF203E32),
      onPrimaryContainer: const Color(0xFF7CE3BE),
      onSurface: const Color(0xFFEDF3F0),
      onSurfaceVariant: const Color(0xFF9AADA5),
      error: const Color(0xFFFFAAA4),
    );
  }
  return scheme;
}

@riverpod
Brightness currentBrightness(Ref ref) {
  final themeMode = ref.watch(
    themeSettingProvider.select((state) => state.themeMode),
  );
  final systemBrightness = ref.watch(systemBrightnessProvider);
  return switch (themeMode) {
    ThemeMode.system => systemBrightness,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}
