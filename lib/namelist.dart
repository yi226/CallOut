import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetNameList extends StatefulWidget {
  const GetNameList({Key? key}) : super(key: key);

  @override
  State<GetNameList> createState() => _GetNameListState();
}

class _GetNameListState extends State<GetNameList> {
  final _textContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("解析人员名单"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: TextField(
                controller: _textContent,
                keyboardType: TextInputType.multiline,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r"[0-9,a-z,A-Z,\u4e00-\u9fa5,\n]"))
                ],
                maxLines: 30,
                minLines: 1,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  hintText: '请输入姓名加回车(最多30个)',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  isDense: true,
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _textContent.text);
          },
          tooltip: '确定',
          backgroundColor: Colors.green,
          child: const Icon(Icons.check)),
    );
  }
}
