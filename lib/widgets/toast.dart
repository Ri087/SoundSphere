import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showErrorToast(BuildContext context, String errorMessage) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFFD62732),
        textColor: Colors.white,
        fontSize: 18);
  }

  static void showShortErrorToast(BuildContext context, String errorMessage) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFFD62732),
        textColor: Colors.white,
        fontSize: 18);
  }

  static void showSuccessToast(BuildContext context, String succesMessage) {
    Fluttertoast.showToast(
        msg: succesMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFF33D627),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showInfoToast(BuildContext context, String infoMessage) {
    Fluttertoast.showToast(
        msg: infoMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFF2787D6),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showShortInfoToast(BuildContext context, String infoMessage) {
    Fluttertoast.showToast(
        msg: infoMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xFF2787D6),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
