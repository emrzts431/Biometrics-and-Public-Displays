import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:public_display_application/generated/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Image.network(
          //"https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcDdhcmxzeWtud2Rxa295anhyYmsyeDUzanJ6eXhmN3ZlZ3doZTE0MiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/0ihPHfpiExxUr6vz7S/giphy.gif",
          //"https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExaXFiYXFmd3YwOW9icTNkbGcxbnFqZGZ6YTk1amNhb3R1dG1vZXBuZCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/26xBwdIuRJiAIqHwA/giphy.gif",
          height: 520,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 50,
        ),
        AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(S.of(context).welcome,
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
