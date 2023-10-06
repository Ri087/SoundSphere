import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/models/user.dart';
import 'package:SoundSphere/screens/login_email/login_email.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_email/login_email.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<List<Widget>> publicRoomWidgetList;
  final TextEditingController newUsername = TextEditingController();

  int index = 1;

  Future<List<Widget>> addPublicRoomToList(context) async {
    List<Widget> publicRoomWidgets = await Room.getRoomWidgets(context);
    return publicRoomWidgets;
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginEmail())));
    }
    publicRoomWidgetList = addPublicRoomToList(context);
  }

  void reloadData() {
    setState(() {
      publicRoomWidgetList = addPublicRoomToList(context);
    });
  }

  Future openPopUpProfile() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                          border: Border.all(color: Color(0xFF0EE6F1)),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Color(0xFF0EE6F1),
                          size: 40,
                        ),
                        onPressed: () {
                          openPopUpUsername();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Username',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFFF86C9)),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFFFF86C9),
                            size: 40,
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginEmail()));
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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

  Future openPopUpUsername() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF02203A),
          alignment: Alignment.center,
          title: const Text(
            'Change your username',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: newUsername,
                    decoration: InputDecoration(
                      hintText: 'New username',
                      filled: true,
                      fillColor: const Color(0xFF02203A),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                              width: 2.0, color: Color(0xFFFFE681))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                              width: 2.0, color: Color(0xFFFFE681))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          borderSide: const BorderSide(
                              width: 2.0, color: Color(0xFFFFE681))),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(newUsername.text);
                          // ignore: use_build_context_synchronously
                          ToastUtil.showSuccesToast(
                              context, "Success: Username has been updated");
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          newUsername.clear();
                        } catch (e) {
                          print(e);
                          // ignore: use_build_context_synchronously
                          ToastUtil.showErrorToast(
                              context, "Error: An error has occurred");
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => const Size(350, 50)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                const Color.fromARGB(255, 14, 230, 241)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                            side: const BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CONFIRM",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );

  Future openPopUpCreateSphere() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF02203A),
          alignment: Alignment.center,
          content: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Create Sphere',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "ZenDots",
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Name of the sphere',
                        filled: true,
                        fillColor: const Color(0xFF02203A),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextField(
                      minLines: 5,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: const Color(0xFF02203A),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: const BorderSide(
                                width: 2.0, color: Color(0xFFFF86C9))),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Private",
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                  activeColor: const Color(0xFFFF86C9),
                                  value: false,
                                  onChanged: (test) {}),
                              const Text(
                                "Public",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.remove,
                                      color: Colors.white)),
                              const Text(
                                "0",
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => const Size(350, 50)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                const Color.fromARGB(255, 14, 230, 241)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                            side: const BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CREATE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02203A),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color(0xFF02203A),
        leading: Image.asset("assets/images/image_transparent.png"),
        title: const Text(
          "SoundSphere",
          style: TextStyle(
              color: Colors.white, fontFamily: 'ZenDots', fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              openPopUpProfile();
              index++;
            },
            icon: const Icon(
              Icons.person_rounded,
              color: Color(0xffffffff),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search a room',
                    filled: true,
                    fillColor: const Color(0xFF02203A),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                            width: 2.0, color: Color(0xFFFFE681))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                            width: 2.0, color: Color(0xFFFFE681))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                            width: 2.0, color: Color(0xFFFFE681))),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15.0),
                    suffixIcon: Material(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(5)),
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search,
                              color: Color(0xFFFFE681), size: 20)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                backgroundColor: const Color(0xFF0EE6F1),
                color: Colors.white,
                onRefresh: () async {
                  reloadData();
                },
                child: FutureBuilder(
                    future: publicRoomWidgetList,
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = snapshot.data!;
                      } else if (snapshot.hasError) {
                        children = [Text("Result : ${snapshot.error}")];
                      } else {
                        children = [
                          const SizedBox(
                            height: 500,
                            child: Center(
                              child: SizedBox(
                                width: 75,
                                height: 75,
                                child: CircularProgressIndicator(
                                    color: Color(0xFF0EE6F1)),
                              ),
                            ),
                          ),
                        ];
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: children.length,
                            itemBuilder: (ctxt /*context*/, ind) {
                              return children[ind];
                            },
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF86C9),
        foregroundColor: const Color(0xFF02203A),
        onPressed: () {
          index++;
          openPopUpCreateSphere();
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
