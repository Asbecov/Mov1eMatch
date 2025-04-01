import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/widgets/film_card.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  late int _crossAxisCount;
  late TextEditingController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    switch (MediaQuery.sizeOf(context).aspectRatio) {
      case <= 4 / 3 && > 9 / 16:
        _crossAxisCount = 4;
        break;
      case <= 9 / 16:
        _crossAxisCount = 3;
        break;
      default:
        _crossAxisCount = 5;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (context, index) => FilmCard(
                    key: ValueKey(index),
                    image: Image.asset('assets/pine_trees.jpg'),
                    label: 'assets/pine_trees.jpg $index',
                    onDelete: (id) => context.pop(),
                  ),
                  itemCount: 30,
                ),
              ],
            ),
          ),
          Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(borderRadius)),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MovieMatcherTextField(
                    hint: 'найдите фильмы',
                    textEditingController: _controller,
                  ),
                ),
                BottomBarButton(icon: Icons.search_sharp, onTap: () {}),
                BottomBarButton(icon: Icons.arrow_forward, onTap: () {}),
              ],
            ),
          ),
        ],
      );
}

class MovieMatcherTextField extends StatefulWidget {
  const MovieMatcherTextField({
    super.key,
    required this.hint,
    required this.textEditingController,
  });

  final String hint;
  final TextEditingController textEditingController;

  @override
  State<MovieMatcherTextField> createState() => _MovieMatcherTextFieldState();
}

class _MovieMatcherTextFieldState extends State<MovieMatcherTextField> {
  late final FocusNode _focusNode;
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_focusNodeListener);
  }

  @override
  void didChangeDependencies() {
    colorScheme = Theme.of(context).colorScheme;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _focusNodeListener() => setState(() {});

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.text,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            height: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                width: rimSize,
                color: _focusNode.hasFocus
                    ? colorScheme.outline
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Material(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(borderRadius),
              child: TextField(
                scrollPadding: EdgeInsets.zero,
                focusNode: _focusNode,
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  constraints: BoxConstraints.expand(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: widget.hint,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ),
        ),
      );
}

class BottomBarButton extends StatefulWidget {
  const BottomBarButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final void Function() onTap;

  @override
  State<BottomBarButton> createState() => _BottomBarButtonState();
}

class _BottomBarButtonState extends State<BottomBarButton> {
  bool _focused = false;

  void _handleFocusChange(bool isFocused) => setState(() {
        _focused = isFocused;
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color:
                _focused ? themeData.colorScheme.outline : Colors.transparent,
            width: rimSize,
          ),
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Material(
            color: themeData.colorScheme.primaryContainer,
            child: InkWell(
              onFocusChange: _handleFocusChange,
              onTap: widget.onTap,
              child: Center(
                child: Icon(widget.icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
