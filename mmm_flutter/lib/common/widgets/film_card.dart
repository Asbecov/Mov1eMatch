import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({
    super.key,
    required this.image,
    required this.onDelete,
  });

  final Image image;
  final void Function(Key? key) onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double buttonSize = constraints.maxHeight / 5;

          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              image,
              SizedBox.square(
                dimension: buttonSize,
                child: FocusableButton(
                  onTap: () => onDelete(super.key),
                  icon: Icons.delete_forever_sharp,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class FocusableButton extends StatefulWidget {
  const FocusableButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final IconData icon;
  final void Function() onTap;

  @override
  State<FocusableButton> createState() => _FocusableButtonState();
}

class _FocusableButtonState extends State<FocusableButton> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode(
      descendantsAreFocusable: false,
      descendantsAreTraversable: false,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Focus(
        focusNode: focusNode,
        child: FocusableButtonRenderWidget(
          focused: focusNode.hasFocus,
          onTap: widget.onTap,
          child: Icon(widget.icon),
        ),
      );
}

class FocusableButtonRenderWidget extends SingleChildRenderObjectWidget {
  const FocusableButtonRenderWidget({
    super.key,
    required this.focused,
    required this.onTap,
    required super.child,
  });

  final bool focused;
  final void Function() onTap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      FocusableButtonRenderObject(
        focused: focused,
        onTap: onTap,
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    if (renderObject is FocusableButtonRenderObject) {
      renderObject.focused = focused;
    } else {
      super.updateRenderObject(context, renderObject);
    }
  }
}

class FocusableButtonRenderObject extends RenderBox
    with RenderObjectWithChildMixin {
  FocusableButtonRenderObject({
    required bool focused,
    required this.onTap,
  }) : _focused = focused;

  final void Function() onTap;
  bool _focused;

  set focused(bool focused) {
    _focused = focused;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void performLayout() {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;

    size = constraints.constrain(Size(width, height));
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!(Offset.zero & size).contains(position)) return false;

    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void handleEvent(
      PointerEvent event, covariant HitTestEntry<HitTestTarget> entry) {
    if (event is PointerDownEvent) onTap();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect rect = offset & size;

    final Path path = Path()
      ..moveTo(0, rect.bottom)
      ..arcTo(offset & (size * 2), pi, pi / 2, false)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(0, rect.bottom)
      ..close();

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    final Paint focusPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white;

    context.canvas.drawPath(path, paint);
    if (_focused) context.canvas.drawPath(path, focusPaint);

    child?.paint(context, offset);
  }
}
