import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/modules/authentication/pages/shop/shop_info_2.dart';
import 'package:happy_tokens/modules/user/models/category_model.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';

import '../../../../helpers/colors.dart';

class ShopInfo1 extends StatefulWidget {
  const ShopInfo1({super.key});

  @override
  State<ShopInfo1> createState() => _ShopInfo1State();
}

class _ShopInfo1State extends State<ShopInfo1> {
  final nameController = TextEditingController();
  final ownerName = TextEditingController();
  final ownerEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthenticationController());
  String? _selectedValue;
  String? selectCategoryId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.getCategory();
  }

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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Shop Details',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Customer will see this on Happy Token App',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Shop Name',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter shop name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Enter your shop name',
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
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(AppColors.buttonInactiveColor),
                      hintText: 'Select your shop category',
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    value: _selectedValue,
                    items: authController.category
                        .map<DropdownMenuItem<String>>((CategoryData value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                        selectCategoryId = authController.category
                            .firstWhere((p0) => p0.name == newValue)
                            .id;
                        print('category $_selectedValue id $selectCategoryId');
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null; // Validation passed
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Shop Owner Name',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ownerName,
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Enter owner name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Enter shop owner name',
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
                const Text(
                  'Shop Owner Email',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ownerEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter owner email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Enter shop owner email',
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

      ///AIzaSyCqN-UmXfm_2eFJNRialgRvO1Utmn8IZPE
      bottomSheet: ButtonNoRadius(
          function: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              authController.shopName.value = nameController.text.trim();
              authController.categoryName.value = _selectedValue!;
              authController.categoryId.value = selectCategoryId!;
              authController.shopOwnerName.value = ownerName.text.trim();
              authController.showOwnerEmail.value = ownerEmail.text.trim();

              Get.to(() => ShopInfo2());
            }
          },
          text: 'Next',
          active: true),
    );
  }
}
