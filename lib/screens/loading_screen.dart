import 'dart:convert';
import 'dart:io';
import 'package:easy_recipe/screens/RecipeDescription.dart';
import 'package:easy_recipe/sqlite/models/IngredientsArguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../sqlite/models/RecipeArgument.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  String recipe = "";
  late IngredientsArguments ingredients;

  @override
  Widget build(BuildContext context) {
    ingredients = ModalRoute.of(context)!.settings.arguments as IngredientsArguments;
    generateRecipe();

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
// "Write a recipe based on these ingredients and instructions:\n\nFrito Pie\n\nIngredients:\nFritos\nChili\nShredded cheddar cheese\nSweet white or red onions, diced small\nSour cream\n\nInstructions:"
  Future<void> generateRecipe() async {

    // ingredients.ingredients.toString().replaceAllMapped(RegExp(), (match) { return '"${match.group(0)}"'; })
    try {
      var response = await http
          .post(
            Uri.parse("https://api.openai.com/v1/completions"),
            headers: {
              HttpHeaders.authorizationHeader:
                  "Bearer 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",
              HttpHeaders.acceptHeader: "application/json",
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode({
              "model": "text-davinci-002",
              "prompt":
                  "Write a recipe based on these ingredients and instructions:\n\n${ingredients.ingredients.toString().replaceAll(",", "").replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "")}\n\nInstructions:",
              "temperature": 0.3,
              "max_tokens": 120,
              "top_p": 1,
              "frequency_penalty": 0.0,
              "presence_penalty": 0.0
            }),
          )
          .timeout(const Duration(seconds: 20));
      recipe = json.decode(response.body)["choices"][0]["text"];
    } on Exception catch (_e) {
      print('$_e reached');
    } finally {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const RecipeDescription(),
              settings: RouteSettings(arguments: RecipeArgument(recipe))),
          ModalRoute.withName("/"));
    }
  }
}
