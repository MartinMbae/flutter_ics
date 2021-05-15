import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> navigateToPageRemoveHistory(
    BuildContext context, Widget newRoute) async {
  return await Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => newRoute), (route) => false);
}

Future navigateToPage(context, page) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void showCustomDialog({
  @required String message,
  @required CoolAlertType alertType,
  @required String confirmBtnText,
  @required Function confirmAction,
  @required BuildContext context,
}) {
  CoolAlert.show(
      context: context,
      type: alertType,
      text: message,
      barrierDismissible: false,
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: () {
        confirmAction();
      });
}


String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  DateFormat format = DateFormat('dd MMM yyyy hh:mm a');
  String formattedDate = format.format(dateTime);
  return formattedDate;
}

String formatCharges(String amount) {
  double am = double.parse(amount);
  if (am == 0){
    return "Free";
  }else{
    final formatter = new NumberFormat("#,###");
    return "Ksh. ${formatter.format(am)}";
  }
}
