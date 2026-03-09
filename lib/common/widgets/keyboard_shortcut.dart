// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class KeyboardShortcut extends StatefulWidget {
  final Widget child;
  final FocusNode? focusNode;
  final VoidCallback? onPressCtrlS;
  final VoidCallback? onPressEscape;
  final VoidCallback? onPressEnter;
  final VoidCallback? onPressSpace;
  final VoidCallback? onPressF2;
  final VoidCallback? onPressPlus;
  final VoidCallback? onPressMinus;
  final String? debugLabel;
  const KeyboardShortcut({
    super.key,

    this.focusNode,
    required this.child,
    this.onPressCtrlS,
    this.onPressEscape,
    this.onPressEnter,
    this.onPressSpace,
    this.debugLabel,
    this.onPressF2,
    this.onPressMinus,
    this.onPressPlus,
  });

  static void back([dynamic result]) {
    App.back(result);
  }

  @override
  State<KeyboardShortcut> createState() => _KeyboardShortcutState();
}

class _KeyboardShortcutState extends State<KeyboardShortcut> {
  late _ShortCutActionHandler _handler;
  late Key _key;

  @override
  void initState() {
    _key = UniqueKey();
    _handler = _ShortCutActionHandler(
      key: _key,
      context: context,
      debuglabel: widget.debugLabel,
      focusNode: widget.focusNode,
      onPressCtrlS: (key) {
        if (key != _key) return;
        widget.onPressCtrlS?.call();
      },

      onPressEscape: (key) {
        if (key != _key) return;
        widget.onPressEscape?.call();
      },
      onPressEnter: (key) {
        if (key != _key) return;
        widget.onPressEnter?.call();
      },
      onPressSpace: (key) {
        if (key != _key) return;
        widget.onPressSpace?.call();
      },
      onPressF2: (key) {
        if (key != _key) return;
        widget.onPressF2?.call();
      },
      onPressPlus: (key) {
        if (key != _key) return;
        widget.onPressPlus?.call();
      },
      onPressMinus: (key) {
        if (key != _key) return;
        widget.onPressMinus?.call();
      },
    );
    KeyboardBinder.registerListner(_handler);
    "_KeyboardShortcutState:init :${widget.debugLabel}".developerLog();
    super.initState();
  }

  @override
  void dispose() {
    "_KeyboardShortcutState:disp :${widget.debugLabel}".developerLog();
    KeyboardBinder.removeListner(_handler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (1 == 1) {
      return widget.child;
    }

    if (App.isMobileDevice) {
      return widget.child;
    }

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const _SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const _EnterIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const _SpaceIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SaveIntent: CallbackAction(
            onInvoke: (_) {
              debugPrint("Ctrl + S pressed!");
              widget.onPressCtrlS?.call();
              return null;
            },
          ),
          _EscapeIntent: CallbackAction(
            onInvoke: (_) {
              debugPrint("escape pressed!");
              widget.onPressEscape?.call();
              return null;
            },
          ),
          _EnterIntent: CallbackAction(
            onInvoke: (_) {
              debugPrint("enter pressed!");
              widget.onPressEnter?.call();
              return null;
            },
          ),

          _SpaceIntent: CallbackAction(
            onInvoke: (_) {
              debugPrint("space pressed!");
              widget.onPressEnter?.call();
              return null;
            },
          ),
        },

        child: widget.child,
      ),
    );
  }
}

class KeyboardBinder extends StatelessWidget {
  final Widget child;
  const KeyboardBinder({super.key, required this.child});

  static final List<_ShortCutActionHandler> _listners = [];

  static void registerListner(_ShortCutActionHandler actions) {
    "registerListner : ${actions.key}".developerLog();
    _listners.add(actions);
  }

  static void removeListner(_ShortCutActionHandler actions) {
    _listners.removeWhere((e) => e.key == actions.key);
    actions.dispose();
  }

  static _ShortCutActionHandler? topOrNull() {
    for (var x in _listners.reversed) {
      final isCurrent = ModalRoute.of(x.context)?.isCurrent;
      if (isCurrent ?? false) {
        return x;
      }
    }

    return null;
  }

  static _ShortCutActionHandler? lastOrNull() {
    if (_listners.length == 1) {
      return _listners.last;
    }

    return null;
  }

  static void emitEnter() {
    final action = topOrNull();
    action?.onPressEnter?.call(action.key);
  }

  void _debugLog(_ShortCutActionHandler? action, String intent) {
    "$intent:: ${(action?.key, action?.debuglabel)}".developerLog();
  }

  @override
  Widget build(BuildContext context) {
    // if (App.isMobileDevice) {
    //   return child;
    // }

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const _SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const _EnterIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const _SpaceIntent(),
        LogicalKeySet(LogicalKeyboardKey.f2): const _FunctionKeyF2(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.add):
            const _CtrlPlus(),

        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.minus):
            const _CtrlMinus(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SaveIntent: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_SaveIntent");
              action?.onPressCtrlS?.call(action.key);

              return null;
            },
          ),
          _EscapeIntent: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull() ?? lastOrNull();
              _debugLog(action, "_EscapeIntent");
              action?.onPressEscape?.call(action.key);
              return null;
            },
          ),
          _EnterIntent: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_EnterIntent");
              action?.onPressEnter?.call(action.key);
              return null;
            },
          ),
          _SpaceIntent: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_SpaceIntent");
              action?.onPressSpace?.call(action.key);
              return null;
            },
          ),
          _FunctionKeyF2: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_FunctionKeyF2");
              action?.onPressF2?.call(action.key);
              return null;
            },
          ),
          _CtrlPlus: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_CtrlPlus");
              action?.onPressPlus?.call(action.key);
              return null;
            },
          ),
          _CtrlMinus: CallbackAction(
            onInvoke: (_) {
              final action = topOrNull();
              _debugLog(action, "_CtrlMinus");
              action?.onPressMinus?.call(action.key);
              return null;
            },
          ),
        },

        child: child,
      ),
    );
  }
}

class _ShortCutActionHandler {
  final Key key;
  final FocusNode? focusNode;
  final BuildContext context;
  final String? debuglabel;
  ValueChanged<Key>? onPressCtrlS;
  ValueChanged<Key>? onPressEscape;
  ValueChanged<Key>? onPressEnter;
  ValueChanged<Key>? onPressSpace;
  ValueChanged<Key>? onPressF2;
  ValueChanged<Key>? onPressPlus;
  ValueChanged<Key>? onPressMinus;

  _ShortCutActionHandler({
    this.onPressCtrlS,
    this.onPressEscape,
    this.onPressEnter,
    this.onPressSpace,
    this.onPressF2,
    this.onPressPlus,
    this.onPressMinus,
    required this.key,
    required this.focusNode,
    required this.context,
    this.debuglabel,
  });

  void dispose() {
    onPressCtrlS = null;
    onPressEscape = null;
    onPressEnter = null;
    onPressSpace = null;
    onPressF2 = null;
  }
}

class _SaveIntent extends Intent {
  const _SaveIntent();
}

class _EscapeIntent extends Intent {
  const _EscapeIntent();
}

class _EnterIntent extends Intent {
  const _EnterIntent();
}

class _SpaceIntent extends Intent {
  const _SpaceIntent();
}

class _FunctionKeyF2 extends Intent {
  const _FunctionKeyF2();
}

class _CtrlPlus extends Intent {
  const _CtrlPlus();
}

class _CtrlMinus extends Intent {
  const _CtrlMinus();
}
