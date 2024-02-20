import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:public_display_application/generated/l10n.dart';

class FreeCoffeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Image.network(
          "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcDdhcmxzeWtud2Rxa295anhyYmsyeDUzanJ6eXhmN3ZlZ3doZTE0MiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/0ihPHfpiExxUr6vz7S/giphy.gif",
          height: 500,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 50,
        ),
        AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(S.of(context).freeCoffee,
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ],
          repeatForever: true,
          isRepeatingAnimation: true,
        ),
        const SizedBox(
          height: 25,
        ),
        AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              '!!${S.of(context).clickNow}!!',
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          repeatForever: true,
          isRepeatingAnimation: true,
        ),
      ],
    );
  }
}
