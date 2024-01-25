import 'package:flutter/material.dart';

class FreeCoffeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcDdhcmxzeWtud2Rxa295anhyYmsyeDUzanJ6eXhmN3ZlZ3doZTE0MiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/0ihPHfpiExxUr6vz7S/giphy.gif"),
          fit: BoxFit.cover,
          scale: 0.5,
        ),
      ),
    );
  }
}
