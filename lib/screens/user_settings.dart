import 'dart:async';
import 'dart:io';

import 'package:SoundSphere/utils/app_firebase.dart';
import 'package:SoundSphere/widgets/popup/popup_change_password.dart';
import 'package:SoundSphere/widgets/popup/popup_warning_delete_account.dart';
import 'package:SoundSphere/widgets/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../widgets/popup/popup_change_username.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<StatefulWidget> createState() => _UserSettings();
}

class _UserSettings extends State<UserSettings> {
  late final Future<AppUser> _user;

  @override
  void initState() {
    super.initState();
    _user = getUser(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<AppUser> getUser(String uid) async {
    final snapshot = await AppUser.collectionRef.doc(uid).get();
    return snapshot.data()!;
  }

  Future openPopupChangeUsername() => showDialog(
    context: context,
    builder: (BuildContext context) => PopupChangeUsername(),
  );

  Future openPopupChangePassword() => showDialog(
    context: context,
    builder: (BuildContext context) => const PopupChangePassword(),
  );

  Future openPopupDeleteAccount() => showDialog(
    context: context,
    builder: (BuildContext context) => const PopupWarningDeleteAccount(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF02203A),
        leading: BackButton(onPressed: () => Navigator.pop(context),),
        title: const Text("Account"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),

      body: FutureBuilder(
        future: _user,
        builder: (context, snapshot) {
          Widget photo = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(150)),
              child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 50,)
            ),
          );
          List<Widget> displayName = const [Text("Loading...", style: TextStyle(fontSize: 22))];
          String email = "";
          if (snapshot.hasData) {
            AppUser user = snapshot.data!;
            if (user.photoUrl.isNotEmpty) {
              photo = Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.network(user.photoUrl),
                ),
              );
            }
            if (user.displayName.isNotEmpty) {
              displayName = [
                Text(user.displayName, style: const TextStyle(fontSize: 22)),
                IconButton(
                  icon: const Icon(Icons.edit, size: 24,),
                  onPressed: () => openPopupChangeUsername(),
                ),
              ];
            }
            email = user.email;
          } else if (snapshot.hasError) {
            displayName = const [Text("Error while loading your account", style: TextStyle(fontSize: 22))];
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox.square(
                            dimension: 150,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(150),
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["jpg", "png"]);
                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    await AppFirebase.usersImagesRef.child("${FirebaseAuth.instance.currentUser!.uid}.png").putFile(file);
                                    String downloadUrl = await AppFirebase.usersImagesRef.child("${FirebaseAuth.instance.currentUser!.uid}.png").getDownloadURL();
                                    FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl).whenComplete(() {
                                      AppUser.collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).update({"photo_url": downloadUrl}).whenComplete(() {
                                        if (mounted) ToastUtil.showInfoToast(context, "Photo updated");
                                        Navigator.pop(context);
                                      });
                                    });
                                  }
                                },
                                child: photo,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: displayName,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(email, style: const TextStyle(fontSize: 16),),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(7),
                                    onTap: () => openPopupChangePassword(),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(width: 2, color: Colors.white)),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("CHANGE PASSWORD", style: TextStyle(fontSize: 18, color: Colors.white),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.change_circle_outlined, color: Colors.white,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(7),
                                    onTap: () => openPopupDeleteAccount(),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(width: 2, color: Colors.red)),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DELETE ACCOUNT", style: TextStyle(fontSize: 18, color: Colors.red),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete_outline_rounded, color: Colors.red,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}