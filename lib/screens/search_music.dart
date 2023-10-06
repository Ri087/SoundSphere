import 'package:flutter/material.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMusic();
}

class _SearchMusic extends State<SearchMusic> {
  late Future<List<Widget>> publicRoomWidgetList;
  int index = 1;


  @override
  void initState() {
    super.initState();
  }

  void leavePage() {
    Navigator.pop(context);
  }

  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02203A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF86C9), //const Color(0xFF0EE6F1),
        title: typing ? const TextBox() : TextButton(onPressed: (){setState(() {typing = !typing;});}, child: const Text("Click here to search a music", style: TextStyle(color: Colors.white, fontSize: 16)),),
        leading: BackButton(
          onPressed: () {
            leavePage();
          },
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Search a music',
        filled: true,
        fillColor: const Color(0xFF02203A),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      ),
    );
  }
}