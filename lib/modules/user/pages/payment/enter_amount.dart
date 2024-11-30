import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class EnterAmountScreen extends StatefulWidget {
  final String image;
  final String shopName;
  final String shopAddress;
  const EnterAmountScreen(
      {super.key,
      required this.image,
      required this.shopName,
      required this.shopAddress});

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  final billAmountController = TextEditingController();
  bool isWalletSelected = true;

  // String environment = 'UAT_SIM';
  // String appId = '';
  // String merchantId = 'PGTESTPAYUAT';
  // bool enableLogging = true;
  // String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  // String saltIndex = '1';
  // String callBackUrl =
  //     "https://webhook.site/0c6297fb-dab1-4baf-afaa-1bfcdb211504";
  // String body = "";
  // String checkSum = "";
  // Object? result;
  // String apiEndPoint = "/pg/v1/pay";
  // void phonepeInit() {
  //   PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLog)
  //       .then((val) {
  //     result = 'PhonePe SDK Initialized - $val';
  //     updateUI();
  //   }).catchError((error) {
  //     handleError(error);
  //   });
  // }
  //
  // startPgTransaction() {
  //   try {
  //     var response =
  //         PhonePePaymentSdk.startTransaction(body, callBackUrl, checkSum, "");
  //     response
  //         .then((val) => {
  //               setState(() {
  //                 result = val;
  //               })
  //             })
  //         .catchError((error) {
  //       print(error);
  //       return <dynamic>{};
  //     });
  //   } catch (error) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'shop',
            child: Stack(
              children: [
                // Image container
                Container(
                  height: 300,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.image),
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  height: 300,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: Text(
                    widget.shopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    widget.shopAddress,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  )),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                      ),
                      child: TextFormField(
                        controller: billAmountController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Bill Amount',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (billAmountController.text.isEmpty ||
                          int.tryParse(billAmountController.text) == 0) {
                        Utils.showSnackBarError(
                            context: context,
                            title: 'Bill amount is not correct');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  titlePadding: const EdgeInsets.all(10),
                                  contentPadding: const EdgeInsets.all(10),
                                  title: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Choose your payment methods',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Icon(Icons.close),
                                        ],
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        tileColor: Colors.orange.shade100,
                                        title: Text(
                                            'Pay ₹${int.parse(billAmountController.text) - 2}'),
                                        leading: Radio<bool>(
                                          value:
                                              true, // Represents "Pay with Wallet"
                                          groupValue: isWalletSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isWalletSelected = value!;
                                            });
                                          },
                                        ),
                                        subtitle: Text('Wallet Balance: ₹2'),
                                      ),
                                      const SizedBox(height: 5),
                                      ListTile(
                                        tileColor: Colors.orange.shade100,
                                        title: Text(
                                            'Pay ₹${billAmountController.text}'),
                                        leading: Radio<bool>(
                                          value: false,
                                          groupValue: isWalletSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isWalletSelected = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ButtonNoRadius(
                                          function: () {},
                                          text: 'Pay',
                                          active: true),
                                    ],
                                  ),
                                );
                              });
                            });
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(AppColors.appMainColor),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Center(
                        child: Text(
                          'Pay Bill',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// import 'dart:convert';
//
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:happy_tokens/helpers/colors.dart';
// import 'package:happy_tokens/helpers/utils.dart';
// import 'package:happy_tokens/widgets/button_no_radius.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:http/http.dart' as http;
//
// class EnterAmountScreen extends StatefulWidget {
//   final String image;
//   final String shopName;
//   final String shopAddress;
//   const EnterAmountScreen(
//       {super.key,
//       required this.image,
//       required this.shopName,
//       required this.shopAddress});
//
//   @override
//   State<EnterAmountScreen> createState() => _EnterAmountScreenState();
// }
//
// class _EnterAmountScreenState extends State<EnterAmountScreen> {
//   final billAmountController = TextEditingController();
//   bool isWalletSelected = true;
//
//   String environment = "UAT_SIM";
//   String appId = "com.softplix.happytoken.happy_tokens";
//   String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
//
//   String merchantId = "PGTESTPAYUAT";
//   bool enableLogging = true;
//   String checksum = "";
//   String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
//
//   String saltIndex = "1";
//
//   String callbackUrl =
//       "https://webhook.site/0c6297fb-dab1-4baf-afaa-1bfcdb211504";
//
//   String body = "";
//   String apiEndPoint = "/pg/v1/pay";
//
//   Object? result;
//   void phonepeInit() {
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $val';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void startPgTransaction() async {
//     try {
//       var response = PhonePePaymentSdk.startTransaction(
//           body, callbackUrl, checksum, appId);
//       response.then((val) async {
//         if (val != null) {
//           String status = val['status'].toString();
//           String error = val['error'].toString();
//
//           if (status == 'SUCCESS') {
//             result = "Flow complete - status : SUCCESS";
//
//             await checkStatus();
//           } else {
//             result = "Flow complete - status : $status and error $error";
//           }
//         } else {
//           result = "Flow Incomplete";
//         }
//       }).catchError((error) {
//         print('error hh$error');
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       print('error $error');
//       handleError(error);
//     }
//   }
//
//   void handleError(error) {
//     setState(() {
//       result = {"error": error};
//     });
//   }
//
//   checkStatus() async {
//     try {
//       String url =
//           "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId"; //Test
//
//       String concatenatedString =
//           "/pg/v1/status/$merchantId/$transactionId$saltKey";
//
//       var bytes = utf8.encode(concatenatedString);
//       var digest = sha256.convert(bytes);
//       String hashedString = digest.toString();
//
//       //  combine with salt key
//       String xVerify = "$hashedString###$saltIndex";
//
//       Map<String, String> headers = {
//         "Content-Type": "application/json",
//         "X-MERCHANT-ID": merchantId,
//         "X-VERIFY": xVerify,
//       };
//
//       await http.get(Uri.parse(url), headers: headers).then((value) {
//         Map<String, dynamic> res = jsonDecode(value.body);
//
//         try {
//           if (res["code"] == "PAYMENT_SUCCESS" &&
//               res['data']['responseCode'] == "SUCCESS") {
//           } else {}
//         } catch (e) {}
//       });
//     } catch (e) {}
//   }
//
//   getChecksum() {
//     final requestData = {
//       "merchantId": "MERCHANTUAT",
//       "merchantTransactionId": "MT7850590068188104",
//       "merchantUserId": "MUID123",
//       "amount": 10000,
//       "callbackUrl": "https://webhook.site/callback-url",
//       "mobileNumber": "9999999999",
//       "paymentInstrument": {"type": "PAY_PAGE"}
//     };
//
//     String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
//
//     checksum =
//         '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
//
//     return base64Body;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     phonepeInit();
//
//     body = getChecksum().toString();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Phonepe Payment Gateway"),
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 startPgTransaction();
//               },
//               child: Text("Start Transaction"),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text("Result \n $result")
//           ],
//         ),
//       ),
//     );
//   }
// }
