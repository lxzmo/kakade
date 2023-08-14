import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:kakade/kakade.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = <String>[];
  String _aliAuthVersion = '获取阿里云插件版本中';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String aliAuthVersion;
    try {
      aliAuthVersion = await Kakade.getSDKVersion() ?? '未知阿里云插件版本';
      _addLog('获取阿里云插件版本成功: $aliAuthVersion');
    } on PlatformException {
      aliAuthVersion = 'Failed to get ali auth plugin version.';
    }

    if (!mounted) return;

    setState(() {
      _aliAuthVersion = aliAuthVersion;
    });
  }

  void _addLog(String log) {
    if (mounted) {
      setState(() {
        _logs.insert(0, log);
      });
      debugPrint(log);
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_aliAuthVersion),
        ),
        body: Center(
          child: Flex(direction: Axis.vertical, children: [
            _divider('初始化操作'),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("初始化SDK"),
            ),
            _divider('授权页面操作'),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("登录注册场景"),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("更换手机号场景"),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("重置密码场景"),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("绑定新手机号场景"),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("验证绑定手机号场景"),
            ),
            _divider("操作日志"),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 8.0,
                ),
                decoration: ShapeDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                child: ListView(
                  reverse: true,
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  children: List.generate(_logs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: SelectableText(
                        _logs.elementAt(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _divider(String text) {
    const dividerGap = Flexible(flex: 2, child: Divider());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          dividerGap,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
          ),
          dividerGap,
        ],
      ),
    );
  }
}
