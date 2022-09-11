import 'package:flutter/material.dart';
import 'package:yog4life/screens/chatscreen.dart';
import 'package:yog4life/screens/feedaddscreen.dart';
import 'package:yog4life/screens/profilescreen.dart';

class FeedScreen extends StatelessWidget {
  static const routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/215.jpg',
          height: 50,
          width: 50,
        ),
        shape: Border(bottom: BorderSide(color: Colors.black12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://img.icons8.com/bubbles/50/000000/andy-warhol.png')),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pushNamed(FeedAddScreen.routeName),
              child: const Icon(
                Icons.add_box_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: TextButton(
        child: Text(
          "Aaa",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(FeedAddScreen.routeName);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .pushNamed(FeedAddScreen.routeName),
          child: Icon(Icons.add_a_photo)),
    );
  }
}
