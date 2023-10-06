import 'package:flutter/material.dart';

class Search_music extends StatefulWidget {
  const Search_music({super.key});

  @override
  State<StatefulWidget> createState() => _Search_music();
}

class _Search_music extends State<Search_music> {
  late Future<List<Widget>> publicRoomWidgetList;
  int index = 1;


  @override
  void initState() {
    super.initState();
    /* if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const LoginEmail())));
    } */
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02203A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF02203A),
        leading: Image.asset("assets/images/image_transparent.png"),
        title: const Text("SoundSphere", style: TextStyle(color: Colors.white, fontFamily: 'ZenDots', fontSize: 18),),
        actions: [
          IconButton(
            onPressed: () {
              index++;
            }, icon: const Icon(Icons.person_rounded, color: Color(0xffffffff),),)
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0), borderSide: const BorderSide(width: 2.0, color: Color(0xFFFFE681))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                    suffixIcon: Material(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(5)),
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search, color: Color(0xFFFFE681),size: 20)
                      ),
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
                    }
                ),
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
        },
        child: const Icon(Icons.add, size: 30,),
      ),
    );
  }
}