import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Added Firebase Import

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/generate_recipe_screen.dart';
import 'screens/cooking_detail_screen.dart';
import 'screens/plating_showcase_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'models/recipe.dart';

void main() async {
  // Ensure framework bindings are fully initialized before asynchronous tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (CRITICAL ADDITION)
  await Firebase.initializeApp();

  // Enforce edge-to-edge transparent system navigation bar and dark status icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const ChefSyncApp(),
    ),
  );
}

/// Root Application Widget configuring high-end dark culinary aesthetics
class ChefSyncApp extends StatelessWidget {
  const ChefSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefSync',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117), // Deep Obsidian Canvas
        primaryColor: const Color(0xFFF59E0B), // Warm Culinary Amber Accent
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFF10B981), // Emerald Success for checklist completions
          surface: Color(0xFF161B22),
          background: Color(0xFF0D1117),
          error: Color(0xFFEF4444),
          onPrimary: Colors.black,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          headlineMedium: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
            height: 1.5,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        GenerateRecipeScreen.routeName: (_) => const GenerateRecipeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == CookingDetailScreen.routeName) {
          final recipe = settings.arguments as Recipe;
          return MaterialPageRoute(
            builder: (_) => CookingDetailScreen(recipe: recipe),
          );
        }
        if (settings.name == PlatingShowcaseScreen.routeName) {
          final recipe = settings.arguments as Recipe;
          return MaterialPageRoute(
            builder: (_) => PlatingShowcaseScreen(recipe: recipe),
          );
        }
        return null;
      },
    );
  }
}