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
  late Future<List<Widget>> roomWidgets;
  late double _widgetSize;
  final searchController = TextEditingController();
  bool searchPrivateRoom = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const LoginEmail()));
    }
    roomWidgets = Room.getPublicRoomWidgets(reloadData, "");
  }

  void reloadData() {
    setState(() {
      roomWidgets = Room.getPublicRoomWidgets(reloadData, "");
    });
  }

  Future openPopupProfile(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext context) => const PopupProfile()
  );

  Future openPopUpCreateSphere(BuildContext context) => showDialog(
    context: context,
    builder: (BuildContext context) => PopupCreateSphere(onReturn: reloadData),
  );

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    roomWidgets = Room.getPublicRoomWidgets(reloadData, "");
  }

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
                    onChanged: (value) {
                      setState(() {
                        searchPrivateRoom = value.startsWith("#");
                        if (searchPrivateRoom) {
                          roomWidgets = Room.getPrivateRoomWidgets(reloadData, value);
                        } else {
                          roomWidgets = Room.getPublicRoomWidgets(reloadData, value);
                        }
                      });
                    },
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search a sphere here',
                      filled: true,
                      fillColor: const Color(0xFF02203A),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                      suffixIcon: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                          onTap: () {
                            setState(() {
                              searchPrivateRoom = searchController.text.startsWith("#");
                              if (searchPrivateRoom) {
                                roomWidgets = Room.getPrivateRoomWidgets(reloadData, searchController.text);
                              } else {
                                roomWidgets = Room.getPublicRoomWidgets(reloadData, searchController.text);
                              }
                            });
                          },
                          child: const Icon(Icons.search, color: Color(0xFFFFE681), size: 20)
                        ),
                      ),
                      prefixIcon: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                          onTap: () {
                            setState(() {
                              searchPrivateRoom = !searchPrivateRoom;
                              String searchText = searchController.text;

                              if (searchPrivateRoom) {
                                searchText = searchText.startsWith("#") ? searchText : "#$searchText";
                                roomWidgets = Room.getPrivateRoomWidgets(reloadData, searchText);
                              } else {
                                searchText = searchText.replaceAll("#", "");
                                roomWidgets = Room.getPublicRoomWidgets(reloadData, searchText);
                              }

                              searchController.text = searchText;
                            });
                          },
                          child: searchPrivateRoom ? const Icon(Icons.lock_outline, color: Color(0xFFFFE681), size: 20) : const Icon(Icons.lock_open_outlined, color: Color(0xFFFFE681), size: 20),
                        ),
                      )
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
                        future: roomWidgets,
                        builder: (context, snapshot) {
                          List<Widget> listItems;
                          if (snapshot.hasData) {
                            listItems = snapshot.data!;
                          } else if (snapshot.hasError) {
                            listItems = [Text("Result : ${snapshot.error}")];
                          } else {
                            listItems = [
                              SizedBox(
                                height: _widgetSize,
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
