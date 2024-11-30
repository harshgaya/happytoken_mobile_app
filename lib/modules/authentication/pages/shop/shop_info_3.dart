import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/authentication/pages/shop/shop_info_4.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';

import '../../../../helpers/colors.dart';

class ShopInfo3 extends StatefulWidget {
  final String city;
  const ShopInfo3({super.key, required this.city});

  @override
  State<ShopInfo3> createState() => _ShopInfo3State();
}

class _ShopInfo3State extends State<ShopInfo3> {
  final formKey = GlobalKey<FormState>();
  final shopNoController = TextEditingController();
  final floorController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final nearbyLandmarkController = TextEditingController();
  final authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Complete restaurant address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: shopNoController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'shop no. / building no. (optional)',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: floorController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Floor / tower (optional)',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: areaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter area/sector/locality';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Area / sector / Locality*',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  controller: cityController..text = widget.city,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: nearbyLandmarkController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Add any nearby landmark (optional)',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ButtonNoRadius(
        function: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            authController.shopNumber.value = shopNoController.text.trim();
            authController.floor.value = floorController.text.trim();
            authController.area.value = areaController.text.trim();
            authController.landmark.value =
                nearbyLandmarkController.text.trim();

            Get.to(() => ShopInfo4());
          }
        },
        text: 'Next',
        active: true,
      ),
    );
  }
}
