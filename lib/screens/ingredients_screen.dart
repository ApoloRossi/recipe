import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> ingredientList = List.empty(growable: true);

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIngredientFromDataBase();
  }

  void fetchIngredientFromDataBase() {
    //TODO: Fetch from Database
    /*for(int i = 0; i < 15; i++) {
      ingredientList.add(
          'Farinha'
      );
    }*/
  }

  List<Widget> _provideWidgetItems() {
    List<Widget> widgets = List.empty(growable: true);
    for(int i = 0; i < ingredientList.length; i++) {
      widgets.add(
          ListTile(title: Center(child: Text(ingredientList[i])))
      );
    }
    return widgets;
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
                /*color: Colors.green,
                textColor: Colors.white,*/
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    ingredientList.add(_textFieldController.text);
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
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: _provideWidgetItems(),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
