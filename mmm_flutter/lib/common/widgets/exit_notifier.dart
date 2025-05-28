import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExitNotifier extends StatefulWidget {
  const ExitNotifier({super.key, required this.child});

  final Widget child;

  @override
  State<ExitNotifier> createState() => _ExitNotifierState();
}

class _ExitNotifierState extends State<ExitNotifier> {
  bool _canPop = false;
  @override
  Widget build(BuildContext context) => PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (!_canPop) {
            Fluttertoast.showToast(
              msg: "Нажмите еще раз чтобы выйти",
              timeInSecForIosWeb: 2,
            );
            setState(() {
              _canPop = true;
            });
            Timer(
                Duration(seconds: 2),
                () => setState(() {
                      Fluttertoast.cancel();
                      _canPop = false;
                    }));
          }
        },
        child: widget.child,
      );
}
