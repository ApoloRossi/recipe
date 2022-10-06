import 'package:easy_recipe/sqlite/daos/IngredientDao.dart';
import 'package:easy_recipe/sqlite/models/Ingredient.dart';
import 'package:easy_recipe/sqlite/models/IngredientsArguments.dart';
import 'package:flutter/material.dart';

import '../resources/labels.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Ingredient> ingredientList = List.empty(growable: true);
  final IngredientDao ingredientDao = IngredientDao();
  Map<String, bool> selectedFlag = {};

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchIngredientFromDataBase();
  }

  void fetchIngredientFromDataBase() async {
    ingredientList = await ingredientDao.getIngredients();
    setState(() {});
  }

  void onTap(bool isSelected, int index) {
    setState(() {
      selectedFlag[ingredientList[index].name] = !isSelected;
    });
  }

  Widget _buildSelectIcon(bool isSelected, BuildContext context) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Theme.of(context).primaryColor,
    );
  }

  void insertIngredient(String ingredient) {
    ingredientDao.insertIngredient(Ingredient(name: ingredient));
    fetchIngredientFromDataBase();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(ConstLabels.whichProductAdd),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: ConstLabels.productName),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(ConstLabels.cancel),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text(ConstLabels.OK),
                onPressed: () {
                  setState(() {
                    insertIngredient(_textFieldController.text);
                    _textFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: (Text(
                  'Selecione os itens para a sua receita',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                )),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (builder, index) {
                  selectedFlag[ingredientList[index].name] =
                      selectedFlag[ingredientList[index].name] ?? false;
                  bool isSelected =
                      selectedFlag[ingredientList[index].name] ?? false;

                  return ListTile(
                      onTap: () => onTap(isSelected, index),
                      title: Text(ingredientList[index].name),
                      leading: _buildSelectIcon(isSelected, context),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).primaryColor, onPressed: () {
                          ingredientDao.deleteIngredient(ingredientList[index]);
                          fetchIngredientFromDataBase();
                        },
                      ),
                  );
                },
                itemCount: ingredientList.length,
              )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            _displayTextInputDialog(context);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(color: Colors.red)))),
                          child: const Text(ConstLabels.addIngredient)))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            final List<String> selectedIngredients =
                                List.empty(growable: true);

                            for (var element in selectedFlag.entries) {
                              if (element.value == true) {
                                selectedIngredients.add("${element.key}\n");
                              }
                            }

                            if (selectedIngredients.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(ConstLabels.noIngredientsSelected),
                              ));
                            } else {
                              Navigator.pushNamed(context, "/loader", arguments: IngredientsArguments(selectedIngredients));
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  return Colors.green;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                          child: const Text(ConstLabels.generateRecipe))))
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
