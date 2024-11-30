import 'package:flutter/material.dart';
import 'package:happy_tokens/helpers/colors.dart';

class ButtonNoRadius extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final bool active;
  const ButtonNoRadius(
      {super.key,
      required this.function,
      required this.text,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  backgroundColor: Color(active
                      ? AppColors.appMainColor
                      : AppColors.buttonInactiveColor)),
              onPressed: !active
                  ? null
                  : () {
                      function();
                    },
              child: Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 13),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
