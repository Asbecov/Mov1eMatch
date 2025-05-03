import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';

import 'package:mmm/common/widgets/film_card.dart';
import 'package:mmm/common/widgets/selectable_button.dart';
import 'package:mmm/common/widgets/text_field.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  late int _crossAxisCount;

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

  void onSearch(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        showDragHandle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        builder: (context) => SearchModalSheet(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.all(5),
          actions: <Widget>[
            SelectableButton(
              icon: Icons.search,
              onTap: () => onSearch(context),
            ),
            SizedBox(width: 10),
            SelectableButton(icon: Icons.arrow_forward, onTap: () {}),
          ],
        ),
        body: CustomScrollView(
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
                image: AssetImage('assets/pine_trees.jpg'),
                label: 'assets/pine_trees.jpg $index',
                onDelete: (id) {},
              ),
              itemCount: 30,
            ),
          ],
        ),
      );
}

class SearchModalSheet extends StatelessWidget {
  const SearchModalSheet({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: MovieMatcherTextField(
                  hint: "Начните поиск фильмов",
                  textEditingController: TextEditingController(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                10,
                (int index) => SearchSelectableCard(
                  key: ValueKey(index),
                  onTap: (Key key) {},
                  title: 'assets/pine_trees.jpg $index',
                  description: index.toString(),
                  genres: ["Комедия", "Приколы", "Рофлы"],
                  image: AssetImage('assets/pine_trees.jpg'),
                ),
              ),
            ),
          ),
        ],
      );
}

class SearchSelectableCard extends StatefulWidget {
  const SearchSelectableCard({
    required super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.genres,
    required this.image,
  });

  final void Function(Key) onTap;
  final String title;
  final String description;
  final List<String> genres;
  final ImageProvider image;

  @override
  State<SearchSelectableCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchSelectableCard> {
  late final FocusNode _focusNode;

  late ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _colorScheme = Theme.of(context).colorScheme;
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
        height: 240,
        child: Material(
          color: _colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            side: _focusNode.hasFocus
                ? BorderSide(color: _colorScheme.outline, width: rimSize)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: () => widget.onTap(widget.key!),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.0,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Ink(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: widget.image),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.0,
                          children: [
                            Text(widget.title),
                            Text(widget.description),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5.0,
                          children: widget.genres
                              .map<Widget>(
                                (String genre) => Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.primaries[(genre.hashCode %
                                            Colors.primaries.length)
                                        .toInt()],
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Text(genre),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
