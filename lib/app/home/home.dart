import 'package:flutter/material.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final components = appBarBundle();
    return Scaffold(
      appBar: components.appBar,
      drawer: components.drawer,
      body: Center(),
    );
  }
}
