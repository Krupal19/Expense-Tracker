import 'package:expense_trackere/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Below code is user rotate phone but not app in landscape
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

var kColorSeed = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 56, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 181),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.scrim,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        snackBarTheme: const SnackBarThemeData().copyWith(
          backgroundColor: kDarkColorScheme.shadow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.outlineVariant,
            foregroundColor: kDarkColorScheme.onSurface,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.normal,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: kColorSeed,
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorSeed.onPrimaryContainer,
          foregroundColor: kColorSeed.primaryContainer,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorSeed.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorSeed.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorSeed.primaryContainer,
          ),
        ),
        snackBarTheme: const SnackBarThemeData()
            .copyWith(backgroundColor: kColorSeed.onPrimaryContainer),
      ),
      themeMode: ThemeMode.dark,
      home: const Expenses(),
    );
  }
}
