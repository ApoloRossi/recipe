import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoaderPage extends StatefulWidget {

  @override
  State<LoaderPage> createState() => _LoaderPageState();

}

class _LoaderPageState extends State<LoaderPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Colors.white, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator( key: Key("progress"), backgroundColor: Colors.white)
      ],
    ));
  }

  Future<String> generateRecipe() async {
    try {
      var response = await http
          .post(
        Uri.parse("https://api.openai.com/v1/models/{model}"),
        headers: {
          HttpHeaders
              .authorizationHeader: "Bearer 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",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "model": "text-davinci-002",
          "prompt": "Write a recipe based on these ingredients and instructions:\n\nFrito Pie\n\nIngredients:\nFritos\nChili\nShredded cheddar cheese\nSweet white or red onions, diced small\nSour cream\n\nInstructions:",
          "max_tokens": 6,
          "temperature": 0,
          "object": "model",
          "top_p": 1,
          "n": 1,
          "stream": false,
          "logprobs": null,
          "stop": "\n"
        }),
      ).timeout(const Duration(seconds: 120));
    } on Exception catch (_e) {
      print('$_e reached');
    }
    return "";
  }

}

/*Future<String> generateRecipe() async {
    String recipe = await openAI.complete(
        "Write a recipe based on these ingredients and instructions:\n\nFrito Pie\n\nIngredients:\nFritos\nChili\nShredded cheddar cheese\nSweet white or red onions, diced small\nSour cream\n\nInstructions:",
        50);
    print("Testeeeeeeeeeeeeeeeeeee");
    print(recipe);
    return recipe;
  }
}*/