import 'package:flutter/material.dart';

class PopupWarningDeleteRoom extends StatelessWidget {
  final String warningText;
  const PopupWarningDeleteRoom({super.key, required this.warningText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      title: const Text('WARNING', style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
      content: SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(warningText),
              Row()
            ],
          )),
    );
  }

}