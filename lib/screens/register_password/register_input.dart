import 'package:flutter/material.dart';

class RegisterInput extends StatelessWidget {
  const RegisterInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        children: [
          TextField(
            obscureText: true,
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(100, 255, 255, 255)),
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
            ),
          )
        ],
      ),
    );
  }
}
