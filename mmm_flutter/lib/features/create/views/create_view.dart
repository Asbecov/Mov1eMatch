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
  bool _focused = false;
  late double _bottomBarHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bottomBarHeight = MediaQuery.sizeOf(context).height / 6;

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

  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Пример: Слушаем изменения фокуса
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _focused = !_focused;
        });
      } else {
        setState(() {
          _focused = !_focused;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
              flex: 8,
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
            Expanded(
              flex: 1,
              child: Container(
                height: _bottomBarHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(borderRadius)),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _focusNode.requestFocus(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.text,
                          child: Container(
                            alignment: Alignment.center,
                            height: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: _focused
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Stack(
                              children: [
                                EditableText(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  strutStyle: StrutStyle(
                                    fontSize: 16,
                                    height: 0,
                                  ),
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                  cursorColor: Colors.blue,
                                  backgroundCursorColor: Colors.grey,
                                  keyboardType: TextInputType.text,
                                  onChanged: (text) =>
                                      print("Текст изменён: $text"),
                                  onSubmitted: (text) =>
                                      print("Текст отправлен: $text"),
                                  textDirection: TextDirection.ltr,
                                  autofocus: false,
                                  obscureText: false,
                                  maxLines: 1,
                                  selectionControls:
                                      MaterialTextSelectionControls(),
                                ),
                                if (_controller.text.isEmpty &&
                                    !_focusNode.hasFocus)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10), // Отступ слева

                                    child: Text(
                                      "найдите фильмы",
                                      style: TextStyle(
                                        fontSize: 30,
                                        decoration: TextDecoration.none,
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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
            ),
          ],
        ),
      );
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
