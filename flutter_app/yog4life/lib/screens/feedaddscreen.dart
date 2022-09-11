import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class FeedAddScreen extends StatelessWidget {
  static const routeName = '/feedadd';
    // var p!;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);

  //   super.dispose();
  // }

  // @override
  // Future<bool> didPopRoute() {
  //   // TODO: implement didPopRoute
  //   print("pop");
  //   return super.didPopRoute();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // user returned to our app
  //     print("resume");

  //   } else if (state == AppLifecycleState.inactive) {
  //     // app is inactive
  //     print("inactive");
  //   } else if (state == AppLifecycleState.paused) {
  //     // user is about quit our app temporally
  //     print("pause");
  //   } else if (state == AppLifecycleState.detached) {
  //     // app suspended (not used in iOS)
  //     print("detach");
  //   }
  // }

  Future<bool> requestPermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Permission Granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }


  Widget showBody() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        children: [
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: const Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://img.icons8.com/bubbles/50/000000/andy-warhol.png'),
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const FittedBox(
                    child: Text(
                      "posting as @kevalvavaliya",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Rubik',
                          color: Colors.black45),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  TextField(
                    cursorHeight: 30,
                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 22),
                    maxLines: 5,
                    maxLength: 130,
                    decoration: const InputDecoration(
                        hintText: 'What\'s happening?',
                        counter: Offstage(),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: ((context, index) {
                  //       return Container(
                  //         height: 100,
                  //         width: 50,
                  //         child: Image.file(File(files[index].path)),
                  //       );
                  //     }),
                  //     itemCount: files.length,
                  //   ),
                  // )
                ]),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(files);
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Align(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(130, 40),
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: requestPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return showBody();
              } else {
                return CircularProgressIndicator(
                  color: Colors.black,
                );
              }
            } else {
              return CircularProgressIndicator(
                color: Colors.black,
              );
            }
          },
        ));
  }
}
