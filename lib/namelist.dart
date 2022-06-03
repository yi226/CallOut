import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetNameList extends StatefulWidget {
  final ValueChanged<String> onEditingComplete;
  const GetNameList({required this.onEditingComplete, Key? key})
      : super(key: key);

  @override
  State<GetNameList> createState() => _GetNameListState();
}

class _GetNameListState extends State<GetNameList> {
  final _textContent = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '名单名称',
                    hintText: '不能输入大写字母',
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
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"[\u4e00-\u9fa5,0-9,a-z]"))
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "名称不能为空";
                    }
                    return null;
                  },
                )),
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
            if (_formKey.currentState!.validate()) {
              widget.onEditingComplete
                  .call('${_nameController.text}+${_textContent.text}');
              Navigator.pop(context, "1");
            }
          },
          tooltip: '确定',
          backgroundColor: Colors.green,
          child: const Icon(Icons.check)),
    );
  }
}
