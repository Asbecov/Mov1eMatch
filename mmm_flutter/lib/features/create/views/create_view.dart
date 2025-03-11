import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/widgets/film_card.dart';
import 'package:mmm/features/home/widgets/home_button.dart';

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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Center(
            child: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SelectableButton(
                      selected: false,
                      icon: Icons.group_work,
                      label: 'создать',
                      onTap: () {},
                    ),
                    SelectableButton(
                      selected: true,
                      icon: Icons.auto_awesome,
                      label: 'подборки',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
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
                  AspectRatio(
                    aspectRatio: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.search, size: 40),
                      label: SizedBox(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.square(36),
                        backgroundColor: Color.fromARGB(255, 53, 53, 53),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.search, size: 40),
                      label: SizedBox(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.square(56),
                        backgroundColor: Color.fromARGB(255, 53, 53, 53),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
