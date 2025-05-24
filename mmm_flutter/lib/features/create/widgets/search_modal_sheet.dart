import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/constants/assets.dart';

import 'package:movie_match/features/create/domain/create_bloc/bloc.dart';
import 'package:movie_match/features/create/domain/search_bloc/bloc.dart';
import 'package:mmm_client/mmm_client.dart';

import 'package:movie_match/common/widgets/text_field.dart';

import 'package:movie_match/features/create/widgets/search_selectable_card.dart';
import 'package:movie_match/features/create/widgets/selectable_suggestion_button.dart';

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
          SliverToBoxAdapter(
            child: Container(
              height: 60.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: MovieMatcherTextField(
                hint: "Начните поиск фильмов",
                textEditingController: _textEditingController!,
              ),
            ),
          ),
          BlocConsumer<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is SearchErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      kDebugMode
                          ? '${state.error} ${state.stackTrace}'
                          : "Попробуйте позже",
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    showCloseIcon: true,
                    closeIconColor: Theme.of(context).colorScheme.onError,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => current is! SearchErrorState,
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
                        ? NetworkImage(state.results[index - 1].art!.replaceAll(
                            originalImageServerUrl,
                            imagesServerUrl,
                          ))
                        : AssetImage(kUnknown),
                  );
                },
                childCount: state.results.length + 1,
              ),
            ),
          ),
        ],
      );
}
