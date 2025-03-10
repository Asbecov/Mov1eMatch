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
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => FilmCard(
                          key: ValueKey(index),
                          image: Image.asset('assets/pine_trees.jpg'),
                          onDelete: (id) => context.pop(),
                        ),
                        childCount: 30,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2 / 3,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
