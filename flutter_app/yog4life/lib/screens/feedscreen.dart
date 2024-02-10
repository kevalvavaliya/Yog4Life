import 'package:flutter/material.dart';
import 'package:yog4life/provider/authprovider.dart';
import 'package:yog4life/provider/feedprovider.dart';
import 'package:yog4life/screens/feedaddscreen.dart';
import 'package:yog4life/widget/erroryogaman.dart';
import 'package:yog4life/widget/feedWidget.dart';
import 'package:provider/provider.dart';

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
        shape: const Border(bottom: BorderSide(color: Colors.black12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
              backgroundImage:
                  NetworkImage(AuthProvider.authUser.getProfilePIC)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pushNamed(FeedAddScreen.routeName)
                  .then((value) {
                Provider.of<FeedProvider>(context, listen: false).fetchFeeds();
              }),
              child: const Icon(
                Icons.add_box_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<FeedProvider>(context, listen: false).fetchFeeds(),
        
        builder: ((context, snapshot) {
          print("aaa");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == "fail") {
              return Center(
                  child: ErrorYogaMan(
                msg: "Aw snaps!! Something went wrong",
                reload: TextButton(
                  child: const Text("Reload"),
                  onPressed: () =>
                      Provider.of<FeedProvider>(context, listen: false)
                          .fetchFeeds(),
                ),
              ));
            }
            final feedList = Provider.of<FeedProvider>(context)
                .getFeedList
                .reversed
                .toList();
            if (feedList.isEmpty) {
              return ErrorYogaMan(
                msg: "Nothing to see here! You're beyond the borders 👀",
              );
            }
            return RefreshIndicator(
              onRefresh: () => Provider.of<FeedProvider>(context, listen: false)
                  .fetchFeeds(),
                
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return FeedWidget(feeddata: feedList[index]);
                    },
                    itemCount: feedList.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black45,
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return ErrorYogaMan(msg: "Do not run! We are your friends!");
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .pushNamed(FeedAddScreen.routeName)
              .then((value) => Provider.of<FeedProvider>(context, listen: false)
                  .fetchFeeds()),
          child: const Icon(Icons.add_a_photo)),
    );
  }
}
