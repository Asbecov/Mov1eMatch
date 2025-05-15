import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/widgets/selectable_button.dart';
import 'package:mmm/features/voting/domain/voting_bloc/bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:mmm_client/mmm_client.dart';

class VotingView extends StatefulWidget {
  const VotingView({super.key});

  @override
  State<VotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<VotingView> {
  late final CardSwiperController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CardSwiperController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<VotingBloc, VotingState>(
          builder: (context, state) {
            if (state is! VotingErrorState && state.sessionId.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Center(
                      child: CardSwiper(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        controller: _controller,
                        cardBuilder: (context, index, _, horizontalDrag) =>
                            Align(
                          alignment: Alignment.center,
                          child: VotingCard(
                            image: state.results.keys.elementAt(index).art !=
                                    null
                                ? NetworkImage(
                                    state.results.keys.elementAt(index).art!,
                                  )
                                : AssetImage('assets/pine_trees.jpg'),
                            label: state.results.keys.elementAt(index).title,
                          ),
                        ),
                        onSwipe: (previousIndex, currentIndex, direction) {
                          context.read<VotingBloc>().add(
                                VotingSubmitedEvent(
                                  film: state.results.keys
                                      .elementAt(previousIndex),
                                  vote: direction == CardSwiperDirection.left
                                      ? true
                                      : false,
                                ),
                              );

                          return true;
                        },
                        onEnd: () => context.read<VotingBloc>().add(
                              const VotingEndedEvent(),
                            ),
                        cardsCount: state.results.length,
                        allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                          horizontal: true,
                        ),
                        isLoop: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 10.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SelectableButton(
                          icon: Icons.favorite,
                          onTap: () =>
                              _controller.swipe(CardSwiperDirection.left),
                          tooltip: "Привет",
                        ),
                        SelectableButton(
                          icon: Icons.undo,
                          onTap: () => _controller.undo(),
                          tooltip: "Привет",
                        ),
                        SelectableButton(
                          icon: Icons.clear,
                          onTap: () =>
                              _controller.swipe(CardSwiperDirection.right),
                          tooltip: "Привет",
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is! VotingErrorState && state.ended) {
              return Center(
                  child: Text(
                "Голоса были сохранены, \nспасибо!",
                textAlign: TextAlign.center,
              ));
            } else if (state is VotingErrorState &&
                state.error is NotFoundException) {
              return Center(child: Text("Такой сессии не существует"));
            }

            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
          listener: (context, state) {
            if (state is VotingErrorState && state.error is NotFoundException) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    kDebugMode
                        ? "${state.error} ${state.stackTrace}"
                        : "Кажется такой сессии не существует",
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  showCloseIcon: true,
                  closeIconColor: Theme.of(context).colorScheme.onError,
                ),
              );
              return;
            }
            if (state is VotingErrorState) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(
                    kDebugMode
                        ? "${state.error} ${state.stackTrace}"
                        : "Поробуйте позже",
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  showCloseIcon: true,
                  closeIconColor: Theme.of(context).colorScheme.onError,
                ),
              );
              return;
            }
          },
        ),
      );
}

class VotingCard extends StatefulWidget {
  const VotingCard({
    super.key,
    required this.image,
    required this.label,
  });

  final ImageProvider image;
  final String label;

  @override
  State<VotingCard> createState() => _ResultsCardState();
}

class _ResultsCardState extends State<VotingCard> {
  late ThemeData _theme;
  late ColorScheme _colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
    _colorScheme = _theme.colorScheme;
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 2 / 3,
        child: Material(
          color: _colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: widget.image),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.transparent,
                            Colors.black,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        child: Text(
                          widget.label,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
