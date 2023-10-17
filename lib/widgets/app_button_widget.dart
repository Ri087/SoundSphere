import 'package:flutter/material.dart';

class AppButtonWidget extends StatefulWidget {
  const AppButtonWidget({super.key, required this.buttonText, required this.buttonIcon, required this.onPressed});
  final String buttonText;
  final Icon buttonIcon;
  final void Function() onPressed;

  @override
  State<StatefulWidget> createState() => _AppButtonWidget();
}

class _AppButtonWidget extends State<AppButtonWidget> {
  late final String buttonText;
  late final Icon buttonIcon;
  late final void Function() onPressed;
  late List<Widget> rowChildren;
  Color buttonColor = const Color(0xFF0EE6F1);
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    buttonText = widget.buttonText;
    buttonIcon = widget.buttonIcon;
    onPressed = widget.onPressed;
    rowChildren = [
      Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold),),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: buttonIcon,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith((states) => const Size(350, 55)),
        backgroundColor: MaterialStateProperty.resolveWith((states) => buttonColor),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7), side: BorderSide(width: 2.0, color: buttonColor))),
      ),
      onPressed: () {
        setState(() {
          if (clicked) {
            return;
          }
          clicked = true;
          buttonColor = Colors.blueGrey;
          rowChildren = [
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ];
        });
        onPressed();
        setState(() {
          buttonColor = const Color(0xFF0EE6F1);
          clicked = false;
          rowChildren = [
            Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: buttonIcon,
            )
          ];
        });

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      )
    );
  }

}