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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Easy Recipe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> ingredientList = List.empty(growable: true);

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIngredientFromDataBase();
  }

  void fetchIngredientFromDataBase() {
    //TODO: Fetch from Database
    for(int i = 0; i < 5; i++) {
      ingredientList.add(
          'Farinha'
      );
    }
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

  void _addNewIngredient() {
    setState(() {
      ingredientList.add("Leite condensado");
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
        onPressed: _addNewIngredient,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
