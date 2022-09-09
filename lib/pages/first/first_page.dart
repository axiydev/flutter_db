import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/consts/consts.dart';
import 'package:flutter_db/models/user_model.dart';
import 'package:flutter_db/service/hive_db/hv_service.dart';

/*
Mavzu:::Hive Page
*/
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _hiveService = HiveServiceRepo();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      await _hiveService.saveDataToHiveBox<UserModel>(
          key: 'data_user', data: user);
      Consts.scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text('$name saqlandi')));
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

  void _showInfo() {
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
  }

//? delete user from db
  void _deleteUser() async {
    try {
      await _hiveService.deleteDataFromHiveBox(key: 'data_user');
      Consts.scaffoldKey.currentState!
          .showSnackBar(const SnackBar(content: Text('ochirildi')));

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
          leading: const SizedBox(),
          title: const Text('Hive DB '),
        ),
        body: FutureBuilder<UserModel?>(
          future: _hiveService.loadDataFromHiveBox<UserModel>(key: 'data_user'),
          builder: (context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text(
                  'Snapshot has not data',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            UserModel user = snapshot.data!;
            return Card(
              child: ListTile(
                title: Text(user.name!),
                subtitle: Text(user.email!),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      onPressed: _showInfo, icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: _deleteUser,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ]),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showInfo,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
