import 'package:flutter/material.dart';
import 'main.dart';

class UnSelectPage extends StatelessWidget {
  final List<UserInfo> unselectUser;
  const UnSelectPage({Key? key, required this.unselectUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("未交人员名单"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: unselectUser.map(
            (e) {
              return Column(
                children: [
                  Text(
                    e.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            },
          ).toList(),
        ));
  }
}
