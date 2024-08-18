import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 30,
        fontWeight: FontWeight.w600
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: GoogleFonts.nunito(
        fontSize: 16,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 16,
        color: Colors.grey.shade600
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 20
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 24
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 35,
        fontWeight: FontWeight.bold
      )
    );
ThemeData lightMode = ThemeData(

  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primaryContainer: Colors.grey.shade300,
    secondaryContainer: Colors.grey.shade600,
    primary: Colors.green.shade100,
    inversePrimary: Colors.green.shade400,
    inverseSurface: Colors.black,
    
    ),
    textTheme: textTheme,
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: const Color.fromARGB(255, 17, 74, 20),
    primaryContainer: Colors.grey.shade800,
    secondaryContainer: Colors.grey.shade500,
    inversePrimary: const Color.fromARGB(255, 121, 215, 125),
    inverseSurface: Colors.white,
    
  ),
  textTheme: textTheme
);

ThemeData rangeColorsLight = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.red.shade800,
    onPrimary: Colors.red.shade100,
    secondary: const Color.fromARGB(255,245,189,0),
    onSecondary: const Color.fromARGB(255, 255, 236, 172),
    
  ),
);

ThemeData iconColorsLight = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.purple.shade700,
    secondary: Colors.blue.shade600,
  )
);
ThemeData rangeColorsDark = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 255, 72, 59),
    onPrimary: Color.fromARGB(255, 71, 0, 0),
    secondary: Colors.yellow,
    onSecondary: Color.fromARGB(255, 101, 91, 0),
  ),
);

ThemeData iconColorsDark = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.purple.shade300,
    secondary: Colors.blue.shade400,
  )
);



class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightMode;
  ThemeData _rangeColors = rangeColorsLight;
  ThemeData _iconColors = iconColorsLight;

  ThemeData get themeData => _themeData;
  ThemeData get rangeColors => _rangeColors;
  ThemeData get iconColors => _iconColors;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  set rangeColors(ThemeData rangeColors){
    _rangeColors = rangeColors;
    notifyListeners();
  }

  set iconColors(ThemeData iconColors){
    _iconColors = iconColors;
    notifyListeners();
  }

  void toggle() {
    if (_themeData == lightMode){
      themeData = darkMode;
      rangeColors = rangeColorsDark;
      iconColors = iconColorsDark;
    } else {
      themeData = lightMode;
      rangeColors = rangeColorsLight;
      iconColors = iconColorsLight;
    }
  }
}