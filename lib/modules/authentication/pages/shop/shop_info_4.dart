import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';

import '../../../../helpers/colors.dart';

class ShopInfo4 extends StatefulWidget {
  const ShopInfo4({super.key});

  @override
  State<ShopInfo4> createState() => _ShopInfo4State();
}

class _ShopInfo4State extends State<ShopInfo4> {
  final authController = Get.put(AuthenticationController());
  final formKey = GlobalKey<FormState>();
  Uint8List? restaurantImage;
  Uint8List? panImage;
  final gstController = TextEditingController();
  final cashbackToCustomer = TextEditingController();
  final bankAccountNumber1 = TextEditingController();
  final bankAccountNumber2 = TextEditingController();

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
                  'Add last information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    restaurantImage = await Utils.pickFile();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: const Color(0xFF276EF0),
                    child: Container(
                      width: Get.width,
                      height: 150,
                      color: const Color(0xFFF1F5FE),
                      child: restaurantImage != null
                          ? Image.memory(restaurantImage!)
                          : const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Color(0xFF276EF0),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Add restaurant image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF276EF0),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    panImage = await Utils.pickFile();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: const Color(0xFF276EF0),
                    child: Container(
                      width: Get.width,
                      height: 150,
                      color: const Color(0xFFF1F5FE),
                      child: panImage != null
                          ? Image.memory(panImage!)
                          : const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Color(0xFF276EF0),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Add PAN Card image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF276EF0),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: gstController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'GST number(optional)',
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
                  controller: cashbackToCustomer,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter cashback you will give to customer';
                    }
                    if (int.parse(value) == 0) {
                      return 'cashback should be greater han 0%';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Cashback to customers in % e.g. 5%, 10%, 20%',
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
                  controller: bankAccountNumber1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter bank account number';
                    }
                    if (bankAccountNumber1.text != bankAccountNumber2.text) {
                      return 'Bank account does not match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Bank Account Number',
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
                  controller: bankAccountNumber2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Re Enter bank account number.';
                    }
                    if (bankAccountNumber1.text != bankAccountNumber2.text) {
                      return 'Bank account does not match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Re Enter Bank Account Number',
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
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Obx(() => authController.addingShopDetails.value
          ? Utils.showLoader()
          : ButtonNoRadius(
              function: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (restaurantImage == null) {
                    Utils.showSnackBarError(
                        context: context, title: 'Add restaurant Image');
                    return;
                  }
                  if (panImage == null) {
                    Utils.showSnackBarError(
                        context: context, title: 'Add PAN Card Image');
                    return;
                  }
                  authController.bankAccount.value =
                      bankAccountNumber1.text.trim();
                  authController.cashbackToCustomer.value =
                      int.parse(cashbackToCustomer.text);
                  await authController.addShopDetails(
                      restaurantImage: restaurantImage!,
                      panImage: panImage!,
                      context: context);
                }
              },
              text: 'Finish',
              active: true,
            )),
    );
  }
}
