import 'package:flutter/material.dart';

class AccountTextIconButtonTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback function;
  const AccountTextIconButtonTile(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 20,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
