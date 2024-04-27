import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // cardTheme: const CardTheme(color: Colors.black),
  cardColor: Colors.blue,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    displaySmall: TextStyle(fontSize: 15, color: Colors.black),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: Colors.blueGrey,
    labelColor: Colors.black,
    dividerColor: Colors.indigo,
    indicatorColor: Colors.teal,
  ),
  appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: Colors.black)),

  // Define your light theme colors, typography, etc.
  // Example:
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey.shade200,
  iconTheme: const IconThemeData(color: Colors.black),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // cardTheme: const CardTheme(color:),
  cardColor: Colors.white54,

  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: Colors.grey,
    labelColor: Colors.teal,
    dividerColor: Colors.indigo,
    indicatorColor: Colors.teal,
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    displaySmall: TextStyle(fontSize: 15, color: Colors.white),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.teal,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: Colors.teal)),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => Colors.transparent))),
  useMaterial3: true,
// Define your dark theme colors, typography, etc.
// Example:
  primarySwatch: Colors.indigo,
  primaryColor: Colors.indigo.shade800,
  iconTheme: const IconThemeData(color: Colors.white),
);

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData = lightTheme;
  bool? _switchValue = false;

  ThemeData? get themeData => _themeData;

  bool? get switchValue => _switchValue;

  ThemeProvider() {
    _themeData;
    _switchValue;
    Future.delayed(const Duration(milliseconds: 10), () {
      loadThemeAndSwitchStatus();
      debugPrint('ten milliseconds has passed.'); // Prints after 1 second.
    });
  }

  Future<void> loadThemeAndSwitchStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? switchValue = prefs.getBool('switchValue');
    notifyListeners();
    if (switchValue != null) {
      _switchValue = switchValue;
      _themeData = _switchValue! ? darkTheme : lightTheme;
    }
  }

  // Future<void> get loadThemeAndSwitchStatus => _loadThemeAndSwitchStatus();

  Future<void> saveSwitchStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchValue', value);
    _switchValue = value;
    _themeData = _switchValue! ? darkTheme : lightTheme;
    notifyListeners();
  }
}
