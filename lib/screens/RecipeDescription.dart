import 'package:easy_recipe/sqlite/models/RecipeArgument.dart';
import 'package:flutter/material.dart';

import '../resources/labels.dart';

class RecipeDescription extends StatelessWidget {
  const RecipeDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeArg =
        ModalRoute.of(context)!.settings.arguments as RecipeArgument;
    return Scaffold(
        appBar: AppBar(
          title: const Text(ConstLabels.appName),
        ),
        body: SingleChildScrollView(
        child : Center(
            child: Column(
          children: [
            const Image(image: AssetImage('assets/food.jpeg')),
            Card(
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child:
                          Text(ConstLabels.bomApetite, style: TextStyle(fontSize: 22))),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(recipeArg.recipe,
                          style: const TextStyle(fontSize: 18)))
                ],
              ),
            )
          ],
        ))));
  }
}
