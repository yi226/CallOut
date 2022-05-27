import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'unselect.dart';
import 'namelist.dart';
import 'searchwidget.dart';

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
  List<UserInfo> searchUser = <UserInfo>[];

  var nameString = '';
  var nameList = [];
  var firstOpen = false;
  int total = 0;

  _CheckHomeState() {
    _get('firstOpen').then((value) {
      if (value == 'f') {
        _get('names').then((value) {
          if (value != null) {
            nameString = value;
            nameList = nameString.split('\n');
          } else {
            nameList = ['学生1', '学生2'];
          }
          addUser();
          setState(() {});
        });
      } else {
        firstOpen = true;
        setState(() {});
      }
    });
  }

  addUser() {
    total = nameList.length;
    for (var i = 0; i < total; i++) {
      userMapList.add(UserInfo(name: nameList[i], id: i));
      unselectUser.add(userMapList[i]);
    }
  }

  Future<String?> _get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString(key);
    return userName;
  }

  _save(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  search(value) {
    searchUser.clear();
    setState(() {
      if (value != null && value != '') {
        for (var i = 0; i < total; i++) {
          if (userMapList[i].name.contains(value)) {
            searchUser.add(userMapList[i]);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstOpen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("初始设置"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '欢迎使用本软件',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              Container(
                height: 50,
              ),
              ElevatedButton(
                child: const Text('初始化人员名单'),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: ((context) => const GetNameList())))
                      .then((value) {
                    if (value != null) {
                      nameString = value;
                      nameList = nameString.split('\n');
                      _save('names', nameString);
                      setState(() {
                        userMapList.clear();
                        unselectUser.clear();
                        addUser();
                        firstOpen = false;
                      });
                      _save('firstOpen', 'f');
                    }
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("点名器"),
          centerTitle: true,
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: SearchWidget(
                    onEditingComplete: search,
                  ),
                ),
                Expanded(
                  child: ListView(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 15),
                      children:
                          (searchUser.isNotEmpty ? searchUser : userMapList)
                              .map((e) {
                        return Column(
                          children: [
                            CheckboxListTile(
                                title: Text(e.name,
                                    style: e.isSelected
                                        ? const TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough)
                                        : const TextStyle(color: Colors.black)),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                ),
              ],
            )),
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
              const Divider(),
              Container(
                height: 100,
              ),
              ElevatedButton(
                child: const Text('解析人员名单'),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: ((context) => const GetNameList())))
                      .then((value) {
                    if (value != null) {
                      nameString = value;
                      nameList = nameString.split('\n');
                      _save('names', nameString);
                      setState(() {
                        userMapList.clear();
                        unselectUser.clear();
                        addUser();
                      });
                    }
                    Navigator.of(context).pop();
                  });
                },
              ),
              Container(
                height: 200,
              ),
              ElevatedButton(
                child: const Text('清空'),
                onPressed: () {
                  setState(() {
                    userMapList.clear();
                    unselectUser.clear();
                    addUser();
                  });
                  Navigator.of(context).pop();
                },
              )
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
}

class UserInfo {
  String name;
  int id;
  bool isSelected;
  UserInfo({required this.name, required this.id, this.isSelected = false});
}
