import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(child: Column(children: [
        Text("This is a dashboard page for $name"),
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('Back'))
      ],))
    );
  }
}
