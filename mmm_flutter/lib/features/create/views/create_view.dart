import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/common/constants/app_constants.dart';

import 'package:mmm/common/widgets/film_card.dart';
import 'package:mmm/common/widgets/selectable_button.dart';
import 'package:mmm/common/widgets/text_field.dart';
import 'package:mmm/features/create/domain/create_bloc/bloc.dart';
import 'package:mmm/features/create/domain/search_bloc/bloc.dart';
import 'package:mmm_client/mmm_client.dart';

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
              tooltip: 'Поиск',
              onTap: () => onSearch(context),
            ),
            SizedBox(width: 10),
            SelectableButton(
              icon: Icons.arrow_forward,
              tooltip: 'Дальше',
              onTap: () {},
            ),
          ],
        ),
        body: BlocBuilder<CreateBloc, CreateState>(
          builder: (context, state) => state.selection.isNotEmpty
              ? CustomScrollView(
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
                        image: state.selection[index].art != null
                            ? NetworkImage(state.selection[index].art!)
                            : AssetImage('assets/pine_trees.jpg'),
                        label: state.selection[index].title,
                        onDelete: (id) => context.read<CreateBloc>().add(
                              RemoveEntryEvent(
                                  index: (id as ValueKey<int>).value),
                            ),
                      ),
                      itemCount: state.selection.length,
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Кажется тут ничего нету,\n попробуйте добавить фильмы через функцию поиска!',
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      );
}

class SearchModalSheet extends StatefulWidget {
  const SearchModalSheet({super.key});

  @override
  State<SearchModalSheet> createState() => _SearchModalSheetState();
}

class _SearchModalSheetState extends State<SearchModalSheet> {
  TextEditingController? _textEditingController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController()
      ..addListener(() => _textEditingControllerListener(context))
      ..value = TextEditingValue(
        text: context.read<SearchBloc>().state.currentQuery,
        selection: TextSelection.collapsed(offset: -1),
        composing: TextRange.collapsed(-1),
      );

    _scrollController = ScrollController()
      ..addListener(() => _scrollControllerListener(context));
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    _scrollController?.dispose();

    super.dispose();
  }

  void _textEditingControllerListener(BuildContext context) =>
      context.read<SearchBloc>().add(ChangedSearchQueryEvent(
            newQuery: _textEditingController?.text ?? '',
          ));

  void _scrollControllerListener(BuildContext context) {
    if (_scrollController != null &&
        _scrollController!.position.pixels >
            (_scrollController!.position.maxScrollExtent * 0.7)) {
      context.read<SearchBloc>().add(HitBottomEvent());
    }
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        controller: _scrollController,
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
                  textEditingController: _textEditingController!,
                ),
              ),
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return SelectableSuggestionButton(
                      onTap: () => context.read<CreateBloc>().add(
                            AddEntryEvent(
                              entry: Film(
                                title: _textEditingController?.text ?? '',
                                genres: [],
                              ),
                            ),
                          ),
                      suggestion:
                          "Добавить фильм с названием: ${_textEditingController?.text ?? ''}",
                    );
                  }
                  return SearchSelectableCard(
                    key: ValueKey(index - 1),
                    onTap: (key) =>
                        context.read<CreateBloc>().add(AddEntryEvent(
                              entry: state.results[(key as ValueKey).value],
                            )),
                    title: state.results[index - 1].title,
                    description: state.results[index - 1].description ?? '',
                    genres: state.results[index - 1].genres,
                    image: state.results[index - 1].art != null
                        ? NetworkImage(state.results[index - 1].art!)
                        : AssetImage('assets/pine_trees.jpg'),
                  );
                },
                childCount: state.results.length + 1,
              ),
            ),
          ),
        ],
      );
}

class SelectableSuggestionButton extends StatefulWidget {
  const SelectableSuggestionButton({
    super.key,
    required this.onTap,
    required this.suggestion,
  });

  final void Function() onTap;
  final String suggestion;

  @override
  State<SelectableSuggestionButton> createState() =>
      _SelectableSuggestionButtonState();
}

class _SelectableSuggestionButtonState
    extends State<SelectableSuggestionButton> {
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
        height: 60,
        child: Material(
          color: _colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: _focusNode.hasFocus
                ? BorderSide(color: _colorScheme.outline, width: rimSize)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.suggestion),
              ),
            ),
          ),
        ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5.0,
                        children: <Widget>[
                          Text(widget.title),
                          Expanded(
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _colorScheme.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    widget.description,
                                    softWrap: true,
                                    maxLines: null,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5.0,
                            children: widget.genres
                                .getRange(0, widget.genres.length >= 3 ? 2 : 0)
                                .map<Widget>(
                              (String genre) {
                                final int colorIndex =
                                    (genre.hashCode % Colors.primaries.length)
                                        .toInt();
                                final Color color =
                                    Colors.primaries[colorIndex];

                                return Ink(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(
                                      borderRadius,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Text(genre),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
