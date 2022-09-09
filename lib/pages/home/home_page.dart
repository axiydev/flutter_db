import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/consts/consts.dart';
import 'package:flutter_db/models/user_model.dart';
import 'package:flutter_db/service/prefs/prefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefs = PrefsService();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> _listUsers = [];

  void initPrefsData() async {
    final dataList = await _prefs.loadDataFromPrefs<List<String>>(key: 'data');
    _listUsers.addAll(dataList!);
  }

  @override
  void initState() {
    initPrefsData();
    super.initState();
  }

//? sava data to database
  void _saveDataToPrefs() async {
    final name = _nameController.text;
    final age = _ageController.text;
    final email = _emailController.text;
    final pasword = _passwordController.text;
    if (name.isEmpty || age.isEmpty || email.isEmpty || pasword.isEmpty) {
      return;
    }
    try {
      UserModel user = UserModel(
          name: name, age: int.tryParse(age), email: email, password: pasword);
      final String userData = jsonEncode(user.toJson());

      _listUsers.add(userData);

      final isSaved = await _prefs.saveDataToPrefs<List<String>>(
          key: 'data', data: _listUsers);
      if (isSaved!) {
        Consts.scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text('$name saqlandi')));
      } else {
        Consts.scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text('$name qoshilmadi')));
      }
      _clearController();
      setState(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//? delete user from db
  void _deleteUser(int? index) async {
    try {
      _listUsers.removeAt(index!);

      final isSaved = await _prefs.saveDataToPrefs<List<String>>(
          key: 'data', data: _listUsers);
      if (isSaved!) {
        Consts.scaffoldKey.currentState!
            .showSnackBar(const SnackBar(content: Text('ochirildi')));
      }
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _clearController() {
    _ageController.clear();
    _emailController.clear();
    _nameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences'),
          elevation: .0,
          bottomOpacity: .0,
          centerTitle: true,
        ),
        body: FutureBuilder<List<String>?>(
            future: _prefs.loadDataFromPrefs<List<String>>(key: 'data'),
            builder: (context, AsyncSnapshot<List<String>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    'Snapshot has not data',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 20),
                  ),
                );
              }

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user =
                        UserModel.fromJson(jsonDecode(snapshot.data![index]));
                    return Card(
                      child: ListTile(
                        title: Text(user.name!),
                        subtitle: Text(user.email!),
                        dense: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () => _deleteUser(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<CupertinoAlertDialog>(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('user malumotlarini kirit'),
                    content: Card(
                      elevation: .0,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoTextField(
                            controller: _nameController,
                            placeholder: 'name',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            controller: _ageController,
                            placeholder: 'age',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            controller: _emailController,
                            placeholder: 'email',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            placeholder: 'password',
                            controller: _passwordController,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: _saveDataToPrefs,
                        child: const Text('save'),
                      ),
                      CupertinoDialogAction(
                        child: const Text('discard'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
          child: const Icon(CupertinoIcons.add),
        ),
      );
    });
  }
}
