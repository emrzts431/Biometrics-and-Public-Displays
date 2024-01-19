import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class FilterObject extends StatelessWidget {
  String filter;
  FilterObject({required this.filter});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
        color: Color.fromARGB(181, 194, 193, 193),
      ),
      child: Row(
        children: [
          Text(filter),
          IconButton(
            onPressed: () {
              //context.read<UserViewModel>().
              //Remove filter
            },
            icon: const Icon(CupertinoIcons.trash),
          ),
        ],
      ),
    );
  }
}
