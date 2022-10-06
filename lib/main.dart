import 'package:easy_recipe/screens/recipe_description.dart';
import 'package:easy_recipe/screens/ingredients_screen.dart';
import 'package:easy_recipe/screens/loading_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Recipe',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        "/": (context) => const MyHomePage(title: 'Easy Recipe'),
        "/loader": (context) =>  const LoaderPage(),
        "/recipe": (context) =>  const RecipeDescription(),
      }

    );
  }
}
