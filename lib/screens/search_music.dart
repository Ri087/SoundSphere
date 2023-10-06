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

  Future openPopUpSettings() => showDialog(
    context: context,
    builder:(context)=> AlertDialog(
      backgroundColor: const Color(0xFF02203A),
      alignment: Alignment.topCenter,
      content: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF86C9)),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Color(0xFFFF86C9),
                    ),
                    onPressed: () {
                      // ADD CODE
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top : 25),
                  child: Text(
                    ' Username',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF86C9)),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.lock_open,
                        color: Color(0xFFFF86C9),
                        size: 26,
                      ),
                      onPressed: () {
                        // ADD CODE
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top :25),
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

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