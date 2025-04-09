import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../network/network_api_services.dart';
import '../network/url_constants.dart';
import 'dart:io';

class Utils {
  static final _apiServices = NetworkApiServices();
  static Widget showLoader() {
    return LoadingAnimationWidget.discreteCircle(
        size: 40,
        color: const Color(AppColors.appMainColor),
        secondRingColor: Colors.red,
        thirdRingColor: Colors.blue);
  }

  static showSnackBarSuccess(
      {required BuildContext context, required String title}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        color: Colors.green,
        title: 'Success!!',
        message: title,
        messageTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showSnackBarError(
      {required BuildContext context, required String title}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(milliseconds: 1000),
      content: AwesomeSnackbarContent(
        color: Colors.red,
        title: 'Error occurred!!',
        message: title,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<Uint8List?> pickFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        String? filePath = result.files.first.path;

        if (filePath != null) {
          File file = File(filePath);
          return await file.readAsBytes();
        } else {
          return result.files.first.bytes;
        }
      } else {
        return null;
      }
    } catch (e) {}
  }

  static Future<String> uploadFileToCloudFlare({
    required Uint8List fileBytes,
    required bool isVideo,
    required BuildContext context,
    required String path,
    required Function(double) onProgress,
  }) async {
    try {
      var uuid = const Uuid();
      String name = uuid.v4();
      String fileNameWithPath = '';

      if (isVideo) {
        fileNameWithPath = 'videos/$name.mp4';
      } else {
        fileNameWithPath = '$path/$name.jpg';
      }

      Dio dio = Dio();
      var data = {
        "fileName": fileNameWithPath,
        "contentType": isVideo ? "video/mp4" : 'image/jpg'
      };

      final response =
          await _apiServices.postApi(data, UrlConstants.generatePreSignedUrl);
      String? signedUrl = response['data'][0]['result'];
      if (signedUrl == null) {
        Utils.showSnackBarError(
            context: context, title: 'unable to upload file');
        return '';
      }

      var options = Options(
        headers: {
          'Content-Type': 'application/octet-stream',
          'Content-Length':
              fileBytes.length.toString(), // Use byte length for web
        },
      );

      await dio.put(
        signedUrl,
        data: Stream.fromIterable(fileBytes.map((e) => [e])),
        options: options,
        // onSendProgress: (int sent, int total) {
        //   double progress = sent / total;
        //   onProgress(progress);
        // },
      );

      // Utils.showSnackBarSuccess(
      //     context: context, title: 'File uploaded successfully!');

      return 'https://d2yhk23ciu9dj0.cloudfront.net/$fileNameWithPath';
    } catch (error) {
      print('error occurrd $error');
      Utils.showSnackBarError(context: context, title: 'unable to upload file');

      return '';
    }
  }

  static String timeToIst({required String timestamp}) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('MMM d yyyy, h:mm a').format(dateTime);
  }

  static void showNonDismissableDialog(
      {required BuildContext context, required String title}) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dialog from being dismissed by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: const Row(
            children: [
              CircularProgressIndicator(), // Loader
            ],
          ),
        );
      },
    );
  }

  static String maskedMobile(String? mobile) {
    if (mobile == null || mobile.length < 3) return '***';
    return '*******${mobile.substring(mobile.length - 3)}';
  }

  static String getTodayShopStatus(Map<String, dynamic> shopTimings) {
    try {
      if (shopTimings.isEmpty) {
        return '';
      }
      String today = DateFormat('EEE').format(DateTime.now());
      String currentTime = DateFormat('hh:mm a').format(DateTime.now());

      String todayTimings = shopTimings[today] ?? "Closed";

      if (todayTimings == "Closed") {
        return "Closed";
      }
      String openingTime = todayTimings.split(" - ")[0];
      DateTime now = DateFormat('hh:mm a').parse(currentTime);
      DateTime openTime = DateFormat('hh:mm a').parse(openingTime);

      if (now.isBefore(openTime)) {
        return "Opens at $openingTime";
      } else {
        return "Open";
      }
    } catch (e) {
      return '';
    }
  }

  static String getDiscountRange(double commission) {
    int lowerBound = (commission / 2).clamp(1, double.infinity).round();
    int upperBound = (commission * 1.5).round();

    return 'Save $lowerBound% to $upperBound% on Bill';
  }
}
