import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'screens/player_setup_screen.dart';
import 'screens/category_select_screen.dart';
import 'screens/gameplay_screens.dart';
import 'screens/result_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: const ZihindarApp(),
    ),
  );
}

class ZihindarApp extends StatelessWidget {
  const ZihindarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zihindar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.orange,
          secondary: AppColors.orangeLight,
          surface: AppColors.surface,
          background: AppColors.background,
          onPrimary: AppColors.white,
          onSurface: AppColors.white,
          onBackground: AppColors.white,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
          ),
          displayMedium: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: AppColors.greyLight,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.greyLight),
          bodySmall: TextStyle(color: AppColors.grey),
          labelLarge: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(color: AppColors.greyLight),
          labelSmall: TextStyle(color: AppColors.grey),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.greyDark, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          labelStyle: const TextStyle(color: AppColors.grey),
          hintStyle: const TextStyle(color: AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.greyDark, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.orange, width: 2),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: const TextStyle(
            color: AppColors.white,
            fontFamily: 'Poppins',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const ZihindarRouter(),
    );
  }
}

// ─── Router — watches GameProvider phase and shows the right screen ───────────
class ZihindarRouter extends StatelessWidget {
  const ZihindarRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GameProvider, GamePhase>(
      selector: (_, p) => p.phase,
      builder: (context, phase, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) {
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                    ),
                child: child,
              ),
            );
          },
          child: _screenForPhase(phase),
        );
      },
    );
  }

  Widget _screenForPhase(GamePhase phase) {
    switch (phase) {
      case GamePhase.home:
        return const HomeScreen(key: ValueKey('home'));
      case GamePhase.playerSetup:
        return const PlayerSetupScreen(key: ValueKey('playerSetup'));
      case GamePhase.categorySelect:
        return const CategorySelectScreen(key: ValueKey('categorySelect'));
      case GamePhase.phonePass:
        return const PhonePassScreen(key: ValueKey('phonePass'));
      case GamePhase.secretTarget:
        return const SecretTargetScreen(key: ValueKey('secretTarget'));
      case GamePhase.clueGiving:
        return const ClueGivingScreen(key: ValueKey('clueGiving'));
      case GamePhase.groupGuess:
        return const GroupGuessScreen(key: ValueKey('groupGuess'));
      case GamePhase.roundResult:
        return const RoundResultScreen(key: ValueKey('roundResult'));
      case GamePhase.gameOver:
        return const GameOverScreen(key: ValueKey('gameOver'));
    }
  }
}
