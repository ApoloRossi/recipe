import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easy_recipe/sqlite/daos/IngredientDao.dart';
import 'package:easy_recipe/sqlite/models/Ingredient.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> ingredientList = List.empty(growable: true);
  final IngredientDao ingredientDao = IngredientDao();
  Map<int, bool> selectedFlag = {};

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIngredientFromDataBase();
  }

  void fetchIngredientFromDataBase() async {
    List<Ingredient> ingredientes = await ingredientDao.getIngredients();

    setState(() {
      for (var element in ingredientes) {
        ingredientList.add(element.name);
      }
    });
  }

  void onTap(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
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
    ingredientList.add(_textFieldController.text);
  }

  Future<String> generateRecipe() async {
    try {
      var response = await http
          .post(
        Uri.parse("https://api.openai.com/v1/completions"),
        headers: {
          HttpHeaders
              .authorizationHeader: "Bearer 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",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "model": "text-davinci-002",
          "prompt": "Write a recipe based on these ingredients and instructions:\n\nFrito Pie\n\nIngredients:\nFritos\nChili\nShredded cheddar cheese\nSweet white or red onions, diced small\nSour cream\n\nInstructions:",
          "temperature": 0.3,
          "max_tokens": 120,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0
        }),
      ).timeout(const Duration(seconds: 20));
      json.decode(response.body);
    } on Exception catch (_e) {
      print('$_e reached');
    }
    return "";
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Qual produto deseja adicionar?'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "nome do produto"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
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
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                )),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (builder, index) {
                  selectedFlag[index] = selectedFlag[index] ?? false;
                  bool isSelected = selectedFlag[index] ?? false;

                  return ListTile(
                      onTap: () => onTap(isSelected, index),
                      title: Text(ingredientList[index]),
                      leading: _buildSelectIcon(isSelected, context));
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
                          child: Text("Adicionar Ingrediente"),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red))))))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            //TODO: Chamar tela de Loading
                            Navigator.pushNamed(context, "/loader");
                            generateRecipe();
                          },
                          child: Text("Gerar Receita"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                    return Colors.green;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0)))))))
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
