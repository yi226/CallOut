import 'package:flutter/material.dart';
import 'unselect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckHome(),
    );
  }
}

class CheckHome extends StatefulWidget {
  const CheckHome({Key? key}) : super(key: key);

  @override
  State<CheckHome> createState() => _CheckHomeState();
}

class _CheckHomeState extends State<CheckHome> {
  List<UserInfo> userMapList = <UserInfo>[];
  List<UserInfo> unselectUser = <UserInfo>[];
  var nameList = [
    '学生1',
    '学生2',
    '学生3',
    '学生4',
    '学生5',
    '学生6'
  ];
  int total = 0;

  _CheckHomeState() {
    addUser();
  }

  addUser() {
    total = nameList.length;
    for (var i = 0; i < total; i++) {
      userMapList.add(UserInfo(name: nameList[i], id: i));
      unselectUser.add(userMapList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("点名器"),
        centerTitle: true,
      ),
      body: ListView(
          padding: const EdgeInsets.all(15),
          children: userMapList.map((e) {
            return Column(
              children: [
                CheckboxListTile(
                    title: Text(e.name,
                        style: e.isSelected
                            ? const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough)
                            : const TextStyle(color: Colors.black)),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: e.isSelected,
                    onChanged: (bool? v) {
                      setState(() {
                        e.isSelected = v!;
                        // 保存未选中的
                        if (!e.isSelected) {
                          if (!unselectUser.contains(e)) {
                            unselectUser.add(e);
                          }
                        } else {
                          if (unselectUser.contains(e)) {
                            unselectUser.remove(e);
                          }
                        }
                      });
                    })
              ],
            );
          }).toList()),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(
                      '设置',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.home),
              ),
              title: Text('学委快乐收作业器'),
            ),
            // ElevatedButton(
            //   child: const Text('清空'),
            //   onPressed: () {
            //     setState(() {
            //       userMapList.map((e) {
            //         e.isSelected = false;
            //       });
            //     });
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (unselectUser.isNotEmpty) {
            unselectUser.sort((a, b) => (a.id).compareTo(b.id));
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) =>
                    UnSelectPage(unselectUser: unselectUser))));
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('恭喜'),
                      content: const Text(('作业已交齐')),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("确定"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          }
        },
        tooltip: '是否交齐',
        backgroundColor: unselectUser.isEmpty ? Colors.blue : Colors.red,
        child: unselectUser.isEmpty
            ? const Icon(Icons.check)
            : Text(unselectUser.length.toString()),
      ),
    );
  }
}

class UserInfo {
  String name;
  int id;
  bool isSelected;
  UserInfo({required this.name, required this.id, this.isSelected = false});
}
