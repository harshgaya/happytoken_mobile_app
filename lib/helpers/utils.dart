import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      print(
          'url file: https://pub-0dd56aa0dbde48edbbf6cd849e9e5560.r2.dev/$fileNameWithPath');

      return 'https://pub-0dd56aa0dbde48edbbf6cd849e9e5560.r2.dev/$fileNameWithPath';
    } catch (error) {
      print('error occurrd $error');
      Utils.showSnackBarError(context: context, title: 'unable to upload file');

      return '';
    }
  }
}
