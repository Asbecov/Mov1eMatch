import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/features/home/widgets/home_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ColorScheme colorScheme = theme.colorScheme;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                colorScheme.secondary,
                colorScheme.onSecondary,
              ],
              begin: Alignment.center,
              end: Alignment(.15, -1),
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: SvgPicture.asset('assets/logotype.svg'),
              ),
            ),
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight / 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HomeButton(
                          icon: Icons.auto_awesome,
                          label: 'подборки',
                          onTap: () {
                            print('ты гей');
                          },
                        ),
                        HomeButton(
                          icon: Icons.group_work,
                          label: 'создать',
                          onTap: () {
                            print('я гей');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
