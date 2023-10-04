import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: "Password",
                hintStyle:
                    const TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                fillColor: Colors.transparent,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color.fromARGB(255, 255, 134, 201),
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 255, 134, 201),
                      style: BorderStyle.solid,
                    ))),
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
