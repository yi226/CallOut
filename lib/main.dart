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
  List<String> saved = <String>[];

  var nameString = '';
  var nameList = [];
  var firstOpen = false;
  int total = 0;
  String barText = '点名器';

  _CheckHomeState() {
    _get('firstOpen').then((value) {
      if (value == 'f') {
        _get("saved").then((value) {
          if (value != null && value != '') {
            String saveNames = value;
            var saveNamesList = saveNames.split('\n');
            _get(saveNamesList[0]).then(((value) {
              setState(() {
                barText = saveNamesList[0];
                saved = saveNames.split('\n');
                if (value != null) {
                  nameString = value;
                  nameList = nameString.split('\n');
                } else {
                  nameList = ['学生1', '学生2'];
                }
                addUser();
              });
            }));
          } else {
            setState(() {
              barText = '示例';
              nameList = ['学生1', '学生2'];
              addUser();
            });
          }
        });
      } else {
        firstOpen = true;
        setState(() {});
      }
    });
  }

  addUser() {
    userMapList.clear();
    unselectUser.clear();
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

  saveList(String saveString) {
    var saveSringList = saveString.split('+');
    String saveName = saveSringList[0];
    String saveValue = saveSringList[1];

    _save(saveName, saveValue);
    if (!saved.contains(saveName)) {
      saved.add(saveName);
      _save("saved", saved.join('\n'));
    }

    setState(() {
      search(null);
      barText = saveName;
      nameString = saveValue;
      nameList = saveValue.split('\n');
      addUser();
    });
  }

  changeList(String saveName) {
    _get(saveName).then((value) {
      if (value != null) {
        setState(() {
          search(null);
          nameString = value;
          nameList = nameString.split('\n');
          addUser();
        });
      }
    });
  }

  deleteList(String removeName) {
    search(null);
    saved.remove(removeName);
    _save("saved", saved.join('\n'));
    _save(removeName, "");
    setState(() {
      if (removeName == barText) {
        if (saved.isNotEmpty) {
          _get(saved[0]).then((value) {
            setState(() {
              barText = saved[0];
              if (value != null) {
                nameString = value;
                nameList = nameString.split('\n');
              } else {
                nameList = ['学生1', '学生2'];
              }
              addUser();
            });
          });
        } else {
          setState(() {
            barText = '示例';
            nameList = ['学生1', '学生2'];
            addUser();
          });
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
                          builder: ((context) => GetNameList(
                                onEditingComplete: saveList,
                              ))))
                      .then((value) {
                    if (value != null) {
                      setState(() {
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
          title: Text(barText),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: SearchWidget(
                onEditingComplete: search,
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: ListView(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                    children: (searchUser.isNotEmpty ? searchUser : userMapList)
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
              ),
            )
          ],
        ),
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
                          builder: ((context) => GetNameList(
                                onEditingComplete: saveList,
                              ))))
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              Container(
                height: 150,
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
        endDrawer: Drawer(
          width: 200,
          child: Column(children: <Widget>[
            Row(
              children: const <Widget>[
                Expanded(
                  // 自定义抽屉头
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      // 背景颜色
                      color: Colors.blue,
                      // 图片
                    ),
                    child: Text("切换名单",
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                )
              ],
            ),
            Expanded(
                child: ListView(
              children: saved.map((e) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Text(e,
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 15)),
                          onPressed: () {
                            changeList(e);
                            barText = e;
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            deleteList(e);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                );
              }).toList(),
            )),
          ]),
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
