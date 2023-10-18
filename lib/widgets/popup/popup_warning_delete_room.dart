import 'package:flutter/material.dart';

class PopupWarningDeleteRoom extends StatelessWidget {
  final String warningText;
  final bool fromPopup;
  const PopupWarningDeleteRoom({super.key, required this.warningText, required this.fromPopup});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
      alignment: Alignment.center,
      title: const Text('WARNING', style: TextStyle(color: Colors.redAccent), textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(warningText, style: const TextStyle(color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (fromPopup) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("CONFIRM"))
              ],
            ),
          )
        ],
      ),
    );
  }

}