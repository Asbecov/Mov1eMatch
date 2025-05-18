import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/constants/assets.dart';
import 'package:mmm/common/constants/routing_constants.dart';

import 'package:mmm/features/create/domain/create_bloc/bloc.dart';
import 'package:mmm/features/create/widgets/search_modal_sheet.dart';

import 'package:mmm/common/widgets/film_card.dart';
import 'package:mmm/common/widgets/selectable_button.dart';

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
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: SvgPicture.asset(
              kTextLogo,
              alignment: Alignment.centerLeft,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          leadingWidth: double.infinity,
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
              onTap: () => context.goNamed(
                sessionName,
                extra: context.read<CreateBloc>().state.selection,
              ),
            ),
          ],
        ),
        body: BlocConsumer<CreateBloc, CreateState>(
          listener: (context, state) {
            if (state is CreateErrorState) {
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
          buildWhen: (previous, current) => current is! CreateErrorState,
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
                            ? NetworkImage(
                                state.selection[index].art!.replaceAll(
                                originalImageServerUrl,
                                imagesServerUrl,
                              ))
                            : AssetImage(kUnknown),
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
                    'Кажется тут ничего нету,\nпопробуйте добавить фильмы через функцию поиска!',
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      );
}
