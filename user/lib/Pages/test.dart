import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toggle List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToggleListExample(),
    );
  }
}

class ToggleListExample extends StatefulWidget {
  const ToggleListExample({super.key});

  @override
  _ToggleListExampleState createState() => _ToggleListExampleState();
}

class _ToggleListExampleState extends State<ToggleListExample> {
  bool showList = false;

  void _toggleList() {
    setState(() {
      showList = !showList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Toggle List Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleList,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Click me",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(
                      showList ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            if (showList)
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Item ${index + 1}"),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
