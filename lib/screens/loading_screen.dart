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
  var hasException = false;

  @override
  Widget build(BuildContext context) {
    ingredients = ModalRoute.of(context)!.settings.arguments as IngredientsArguments;
    generateRecipe();

    if  (hasException) {
      return Scaffold(
        body: Center(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: const EdgeInsets.all(16),
              child: Text("Ocorreu um erro"),
              ),
              ElevatedButton(onPressed: () {
                  setState(() {
                    hasException = false;
                  });
              },
                  child: Text("Tentar novamente"))
            ],
          ),
        ),
      );
    } else {
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
  }

  Future<void> generateRecipe() async {

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
      if (json.decode(response.body)["error"] != null) {
        throw Exception("");
      } else {
        recipe = json.decode(response.body)["choices"][0]["text"];
      }
    } on Exception catch (_e) {
      hasException = true;
      print('$_e reached');
    } finally {
      if (hasException) {
        setState(() {
        });
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
