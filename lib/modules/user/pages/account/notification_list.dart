import 'package:flutter/material.dart';

import '../../controller/user_controller.dart';
import 'package:get/get.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
