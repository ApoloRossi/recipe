import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Colors.white, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [CircularProgressIndicator(key: key, backgroundColor: Colors.white)],
    ));
  }
}
