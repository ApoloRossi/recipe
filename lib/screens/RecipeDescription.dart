import 'package:easy_recipe/sqlite/models/RecipeArgument.dart';
import 'package:flutter/material.dart';

class RecipeDescription extends StatelessWidget {
  const RecipeDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeArg =
        ModalRoute.of(context)!.settings.arguments as RecipeArgument;
    return Scaffold(
        appBar: AppBar(
          title: Text("Sua receita"),
        ),
        body: Center(
          child: Text(recipeArg.recipe),
        ));
  }
}
