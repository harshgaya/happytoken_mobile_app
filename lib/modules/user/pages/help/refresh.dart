import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RefreshIndicatorExample(),
    );
  }
}

class RefreshIndicatorExample extends StatefulWidget {
  @override
  _RefreshIndicatorExampleState createState() =>
      _RefreshIndicatorExampleState();
}

class _RefreshIndicatorExampleState extends State<RefreshIndicatorExample> {
  List<String> items = List.generate(20, (index) => "Item ${index + 1}");

  Future<void> _refresh() async {
    // Simulate a network call or any async operation
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      items = List.generate(20, (index) => "Refreshed Item ${index + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull to Refresh Example'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
      ),
    );
  }
}
