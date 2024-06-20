import 'package:flutter/material.dart';
import 'package:newsapp/Routing/routes_name.dart';
import 'package:newsapp/Screen/categories_screen.dart';
import 'package:newsapp/Screen/home_screen.dart';
import 'package:newsapp/Screen/newsdetail_screen.dart';
import 'package:newsapp/Screen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.SplashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.HomeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case RoutesName.CategoriesScreen:
        return MaterialPageRoute(
          builder: (context) => const CategoriesScreen(),
        );
      case RoutesName.NewsDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => NewsDetailScreen(
            data: settings.arguments as Map,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Define")),
          ),
        );
    }
  }
}
