import 'package:SoundSphere/models/room.dart';
import 'package:SoundSphere/screens/login/email_page.dart';
import 'package:SoundSphere/widgets/popup/popup_create_sphere.dart';
import 'package:SoundSphere/widgets/popup/popup_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<List<Widget>> publicRoomWidgetList;
  late double _widgetSize;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginEmail())));
    }
    publicRoomWidgetList = Room.getPublicRoomWidgets(reloadData);
  }

  void reloadData() {
    setState(() {
      publicRoomWidgetList = Room.getPublicRoomWidgets(reloadData);
    });
  }

  Future openPopupProfile(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext context) => const PopupProfile()
  );

  Future openPopUpCreateSphere(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext context) => const PopupCreateSphere()
  );

  @override
  Widget build(BuildContext context) {
    _widgetSize = MediaQuery.of(context).size.height - AppBar().preferredSize.height - 180 - MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        // Permet de unfocus les textfields quand on tap en dehors du clavier
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: const Color(0xFF02203A),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("assets/images/image_transparent_fit.png"),
          ),
          title: const Text("SoundSphere", style: TextStyle(fontFamily: 'ZenDots', fontSize: 18),),
          actions: [
            IconButton(
              splashRadius: 0.1,
              onPressed: () => openPopupProfile(context),
              icon: const Icon(Icons.person_rounded,),
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
                    onTap: () {
                      setState(() {
                        _widgetSize = MediaQuery.of(context).size.height - AppBar().preferredSize.height - 140 - MediaQuery.of(context).viewInsets.bottom;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search a sphere',
                      filled: true,
                      fillColor: const Color(0xFF02203A),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                      suffixIcon: Material(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(7)),
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.search, color: Color(0xFFFFE681), size: 20)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      backgroundColor: const Color(0xFF0EE6F1),
                      color: Colors.white,
                      onRefresh: () async {
                        reloadData();
                      },
                      child: FutureBuilder(
                        future: publicRoomWidgetList,
                        builder: (context, snapshot) {
                          List<Widget> listItems;
                          if (snapshot.hasData) {
                            listItems = snapshot.data!;
                          } else if (snapshot.hasError) {
                            listItems = [Text("Result : ${snapshot.error}")];
                          } else {
                            listItems = [
                              SizedBox(
                                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                                child: const Center(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(color: Color(0xFF0EE6F1)),
                                  ),
                                ),
                              ),
                            ];
                          }
                          return SizedBox(
                            height: _widgetSize,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: listItems.length,
                                itemBuilder: (ctxt /*context*/, ind) {
                                  return listItems[ind];
                                },
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => openPopUpCreateSphere(context),
          child: const Icon(Icons.add,),
        ),
      ),
    );
  }
}
