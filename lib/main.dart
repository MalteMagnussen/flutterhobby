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
      title: "Malte Hviid-Magnussen",
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
  final _formKey = GlobalKey<FormState>();
  late String value = "";
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
        title: const Text("Malte Hviid-Magnussen - Hobby Projects"),
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
          const SizedBox(
            height: 30,
          ),
          loading
              ? const CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Input your Name',
                          ),
                          onChanged: (_value) => setState(() {
                            value = _value;
                          }),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 70,
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () async {
                          value = value.trim();
                          if (value.length < 2) {
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          try {
                            if (value.length < 2) {
                              throw Exception(
                                  "Name has to be longer than 2 characters.");
                            }
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
                          } on Exception {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Wow, your name is unique!'),
                                  content: const Text(
                                    "No one else is named that in the database.",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Go!",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> onSubmit(String value, BuildContext context) async {
    {
      setState(() {
        loading = true;
      });
      try {
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
      } on Exception {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wow, your name is unique!'),
              content: const Text(
                "No one else is named that in the database.",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      loading = false;
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
