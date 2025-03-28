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
  Uint8List? bankPassbook;
  Uint8List? gstImage;
  Uint8List? businessImage;
  final gstController = TextEditingController();
  final cashbackToCustomer = TextEditingController();
  final bankAccountNumber1 = TextEditingController();
  final bankAccountNumber2 = TextEditingController();
  final bankAccountName = TextEditingController();
  final bankName = TextEditingController();
  final bankBranchName = TextEditingController();
  final bankIFSCCode = TextEditingController();
  final pancardNumber = TextEditingController();
  String? selectedValue;
  List<String> items = [
    "Propritorship",
    "Partnership",
    "Pvt Ltd",
    "Individual"
  ];

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
                                  'Add shop image',
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
                InkWell(
                  onTap: () async {
                    bankPassbook = await Utils.pickFile();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: const Color(0xFF276EF0),
                    child: Container(
                      width: Get.width,
                      height: 150,
                      color: const Color(0xFFF1F5FE),
                      child: bankPassbook != null
                          ? Image.memory(bankPassbook!)
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
                                  'Add cancelled cheque copy / front bank passbook image',
                                  textAlign: TextAlign.center,
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
                    gstImage = await Utils.pickFile();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: const Color(0xFF276EF0),
                    child: Container(
                      width: Get.width,
                      height: 150,
                      color: const Color(0xFFF1F5FE),
                      child: gstImage != null
                          ? Image.memory(gstImage!)
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
                                  'Add GST image (Optional)',
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
                  controller: pancardNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter pancard number';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Pancard number',
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select business type",
                  ),
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select your business type";
                    }
                    return null;
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    businessImage = await Utils.pickFile();
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: const Color(0xFF276EF0),
                    child: Container(
                      width: Get.width,
                      height: 150,
                      color: const Color(0xFFF1F5FE),
                      child: businessImage != null
                          ? Image.memory(businessImage!)
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
                                  'Add Business image (Optional)',
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
                  controller: cashbackToCustomer,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter discount you will give to customer';
                    }
                    if (int.parse(value) == 0) {
                      return 'discount should be greater han 0%';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Discount to customers in % e.g. 5%, 10%, 20%',
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
                  height: 20,
                ),
                TextFormField(
                  controller: bankAccountName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter bank account name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Bank Account Name e.g. ABC Cafe`',
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
                  controller: bankName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter bank  name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Bank Name e.g. SBI, PNB',
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
                  controller: bankBranchName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter bank branch name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Bank Branch Name e.g. SBI East Mumbai`',
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
                  controller: bankIFSCCode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter bank IFSC name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(AppColors.buttonInactiveColor),
                    hintText: 'Bank IFSC Code',
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
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Obx(() => authController.addingShopDetails.value
            ? Utils.showLoader()
            : ButtonNoRadius(
                function: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (restaurantImage == null) {
                      Utils.showSnackBarError(
                          context: context, title: 'Add shop Image');
                      return;
                    }
                    if (panImage == null) {
                      Utils.showSnackBarError(
                          context: context, title: 'Add PAN Card Image');
                      return;
                    }

                    if (bankPassbook == null) {
                      Utils.showSnackBarError(
                          context: context,
                          title:
                              'Add Bank Card cancelled cheque copy / front bank passbook image');
                      return;
                    }
                    if (selectedValue == 'Pvt Ltd' && businessImage == null) {
                      Utils.showSnackBarError(
                          context: context, title: 'Add your business image!');
                      return;
                    }
                    if (gstController.text.isNotEmpty && gstImage == null) {
                      Utils.showSnackBarError(
                          context: context, title: 'Add your GST image!');
                      return;
                    }

                    authController.businessType.value = selectedValue!;
                    authController.gstNumber.value = gstController.text;
                    authController.pancardNumber.value =
                        pancardNumber.text.trim();
                    authController.bankAccount.value =
                        bankAccountNumber1.text.trim();
                    authController.bankAccountName.value =
                        bankAccountName.text.trim();
                    authController.bankName.value = bankName.text.trim();
                    authController.bankBranchName.value =
                        bankBranchName.text.trim();
                    authController.bankIFSCCode.value =
                        bankIFSCCode.text.trim();
                    authController.cashbackToCustomer.value =
                        int.parse(cashbackToCustomer.text);
                    await authController.addShopDetails(
                      businessImage: businessImage,
                      gstImage: gstImage,
                      restaurantImage: restaurantImage!,
                      panImage: panImage!,
                      context: context,
                      bankPassbook: bankPassbook!,
                    );
                  }
                },
                text: 'Finish',
                active: true,
              )),
      ),
    );
  }
}
