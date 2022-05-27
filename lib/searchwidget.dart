import 'package:flutter/material.dart';

/// @author longzipeng
/// @创建时间：2022/3/29
/// 查询组件
class SearchWidget extends StatefulWidget {
  final double? height; // 高度
  final double? width; // 宽度
  final String? hintText; // 输入提示
  final ValueChanged<String>? onEditingComplete; // 编辑完成的事件回调

  const SearchWidget(
      {Key? key,
      this.height,
      this.width,
      this.hintText,
      this.onEditingComplete})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /// 清除查询关键词
  clearKeywords() {
    controller.text = '';
    widget.onEditingComplete?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      var width = widget.width ?? constrains.maxWidth / 1.5; // 父级宽度
      var height = widget.width ?? widget.height ?? 30;
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(height)),
        child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: widget.hintText ?? "请输入搜索词",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: EdgeInsets.only(bottom: height / 3),
                border: InputBorder.none,
                icon: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Icon(
                      Icons.search,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    )),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 17,
                  ),
                  onPressed: clearKeywords,
                  splashColor: Theme.of(context).primaryColor,
                )),
            onChanged: (v) {
              widget.onEditingComplete?.call(controller.text);
            }),
      );
    });
  }
}
