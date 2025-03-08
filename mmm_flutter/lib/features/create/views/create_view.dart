import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/widgets/film_card.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: FilmCard(
            image: Image.asset('assets/pine_trees.jpg'),
            onDelete: (key) {
              print(key);
              context.pop();
            }),
      );
}
