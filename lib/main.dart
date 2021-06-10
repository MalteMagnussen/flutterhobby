import 'package:flutter/material.dart';
import 'agify.dart';
import 'agify_fetch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malte Hviid-Magnussen',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late PersonsAge person;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malte Hviid-Magnussen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "I can guess your age and country!\nTry it out!",
              textAlign: TextAlign.center,
              style: TextStyle(height: 2),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          loading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input your Name',
                    ),
                    onSubmitted: (String value) async {
                      setState(() {
                        loading = true;
                      });
                      PersonsAge tempPerson = await fetchPerson(value);
                      setState(() {
                        person = tempPerson;
                        loading = false;
                      });
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Your name is $value!'),
                            content: Text(
                              "Your age is ${person.age} and you're from ${person.country}!",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
