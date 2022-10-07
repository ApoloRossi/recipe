import 'dart:convert';
import 'package:easy_recipe/resources/labels.dart';
import 'package:easy_recipe/screens/recipe_description.dart';
import 'package:easy_recipe/services/api_service.dart';
import 'package:easy_recipe/sqlite/models/IngredientsArguments.dart';
import 'package:flutter/material.dart';

import '../sqlite/models/RecipeArgument.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  String recipe = "";
  late IngredientsArguments ingredients;
  var hasException = false;

  @override
  Widget build(BuildContext context) {
    ingredients =
        ModalRoute.of(context)!.settings.arguments as IngredientsArguments;

    if (hasException) {
      return errorWidget();
    } else {
      generateRecipe();
      return progressWidget();
    }
  }

  ColoredBox progressWidget() {
    return ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
                key: Key("progress"), backgroundColor: Colors.white)
          ],
        ));
  }

  Scaffold errorWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(ConstLabels.error),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasException = false;
                  });
                },
                child: const Text(ConstLabels.tryAgain))
          ],
        ),
      ),
    );
  }

  Future<void> generateRecipe() async {
    try {
      var response = await ApiService().generateRecipe(ingredients.ingredients);
      if (json.decode(response.body)["error"] != null) {
        throw Exception("");
      } else {
        recipe = json.decode(response.body)["choices"][0]["text"];
      }
    } on Exception catch (_) {
      hasException = true;
    } finally {
      if (hasException) {
        setState(() {});
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const RecipeDescription(),
                settings: RouteSettings(arguments: RecipeArgument(recipe))),
            ModalRoute.withName("/"));
      }
    }
  }
}
