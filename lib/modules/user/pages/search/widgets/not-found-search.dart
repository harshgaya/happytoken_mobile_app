import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotFoundSearch extends StatelessWidget {
  const NotFoundSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/icons/search-not-found.png',
          height: 30,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sorry, No results Found',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: Get.width - 100,
              child: const Text(
                'Try checking your spelling or search for something else',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
