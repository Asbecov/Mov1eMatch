import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'package:mmm/common/constants/assets.dart';
import 'package:mmm/common/widgets/selectable_button.dart';
import 'package:mmm/features/voting/domain/voting_bloc/bloc.dart';
import 'package:mmm/features/voting/widget/voting_card.dart';

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

  Widget _builder(BuildContext context, VotingState state) {
    if (state is! VotingErrorState && state.sessionId.isNotEmpty) {
      return Column(
        children: [
          Text(
            "Смахните налево если вам нравится фильм\nи направо если не нравится",
            textAlign: TextAlign.center,
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: CardSwiper(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                controller: _controller,
                cardBuilder: (context, index, horizontalDrag, _) => Align(
                  alignment: Alignment.center,
                  child: VotingCard(
                    image: state.results.keys.elementAt(index).art != null
                        ? NetworkImage(
                            state.results.keys.elementAt(index).art!,
                          )
                        : AssetImage(kUnknown),
                    horizontalDrag: horizontalDrag,
                    label: state.results.keys.elementAt(index).title,
                  ),
                ),
                onSwipe: (previousIndex, currentIndex, direction) {
                  context.read<VotingBloc>().add(
                        VotingSubmitedEvent(
                          film: state.results.keys.elementAt(previousIndex),
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
                  onTap: () => _controller.swipe(CardSwiperDirection.left),
                  tooltip: "Голос за",
                ),
                SelectableButton(
                  icon: Icons.undo,
                  onTap: () => _controller.undo(),
                  tooltip: "Отмена",
                ),
                SelectableButton(
                  icon: Icons.clear,
                  onTap: () => _controller.swipe(CardSwiperDirection.right),
                  tooltip: "Голос против",
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
    } else if (state is VotingErrorState && state.error is NotFoundException) {
      return Center(child: Text("Такой сессии не существует"));
    }

    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  void _listener(BuildContext context, VotingState state) {
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: SvgPicture.asset(
              kLogo,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          leadingWidth: double.infinity,
        ),
        body: BlocConsumer<VotingBloc, VotingState>(
          builder: _builder,
          listener: _listener,
        ),
      );
}
