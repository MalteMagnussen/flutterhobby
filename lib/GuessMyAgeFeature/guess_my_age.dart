import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import '../widget_view.dart';
import 'agify.dart';
import 'agify_fetch.dart';

class GuessMyAgeWidget extends StatefulWidget {
  const GuessMyAgeWidget({Key? key}) : super(key: key);
  @override
  _GuessMyAgeController createState() => _GuessMyAgeController();
}

class _GuessMyAgeController extends State<GuessMyAgeWidget> {
  late TextEditingController _nameController;
  late TextEditingController _countryController;
  late PersonsAge person;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  late String personsName = "";
  late String country = "";

  @override
  void initState() {
    super.initState();
    person = PersonsAge.nameCountry(personsName, country);
    _nameController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void handleLoading(bool _loading) => setState(() => loading = _loading);
  void setPerson(PersonsAge _person) => setState(() => person = _person);
  Future<void> _fetchPerson() async {
    return setPerson(
      await fetchPerson(personsName, country),
    );
  }

  void handleChangePersonsName(String name) =>
      setState(() => personsName = name);
  void handleChangePersonsCountry(String _country) =>
      setState(() => country = _country);
  void verifyName() {
    setState(() {
      personsName.trim();
      List names = personsName.split(" ");
      personsName = names[0];
      if (personsName.length < 2) {
        throw Exception("Name has to be longer than 2 characters.");
      }
    });
  }

  void verifyCountry() {
    setState(() {
      country.trim();
      if (country.length < 2) {
        throw Exception("Country has to be longer than that.");
      }
    });
  }

  Future<void> handleSubmit() async {
    handleLoading(true);
    verifyName();
    verifyCountry();
    await _fetchPerson();
    handleLoading(false);
  }

  @override
  Widget build(BuildContext context) => _GuessMyAgeView(this);
}

class _GuessMyAgeView
    extends WidgetView<GuessMyAgeWidget, _GuessMyAgeController> {
  _GuessMyAgeView(_GuessMyAgeController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HobbyNavigation(),
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: const Text("Malte Hviid-Magnussen - Hobby Projects"),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "I can guess your age!\nTry it out!",
              textAlign: TextAlign.center,
              style: TextStyle(height: 2),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          state.loading
              ? const CircularProgressIndicator()
              : Form(
                  key: state._formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: state._countryController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Input your Country',
                          ),
                          onChanged: (_value) =>
                              state.handleChangePersonsCountry(_value),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                            controller: state._nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Input your First Name',
                            ),
                            onChanged: (_value) =>
                                state.handleChangePersonsName(_value)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 70,
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () async {
                          try {
                            await state.handleSubmit();
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Text("Your age is ${state.person.age}!"),
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
                          } on Exception catch (error) {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error!'),
                                  content: Text("$error"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        state.handleLoading(false);
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
}
