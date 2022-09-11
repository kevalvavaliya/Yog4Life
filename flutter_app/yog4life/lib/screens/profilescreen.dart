import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yog4life/screens/homepage.dart';
import 'package:provider/provider.dart';
import '../models/feedmodel.dart';
import 'package:yog4life/widget/feedWidget.dart';
import '../widget//profile_card.dart';

import 'package:yog4life/util/utility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/authprovider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  Future<Map<String, dynamic>> fetchFeeds(String id) async {
    List<FeedModel> posts = [];
    final resp =
        await http.post(Uri.parse("${Utility.URL}/user/profile/$id"), headers: {
      "Authorization": "Bearer ${AuthProvider.authUser.gettoken}",
    });
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data["message"] == "User profile fetched successfully") {
        posts = data["data"]["users_blogs"]
            .map<FeedModel>((feed) => FeedModel(
                username: feed["author"]["username"],
                postImage: feed["image"],
                postDescription: feed["description"],
                profileImage: feed["author"]["profile_pic"],
                userId: feed["author"]["_id"]))
            .toList();
        AuthProvider.authUser.setprofilePIC =
            data["data"]["user"]["profile_pic"];

        return {
          'message': "sucess",
          "data": posts,
          "username": data["data"]["user"]["username"],
          "image": data["data"]["user"]["profile_pic"],
        };
      } else {
        print(data["message"]);
        return {
          'message': "fail",
          "errorMessage": data["message"],
        };
      }
    } else {
      return {'message': "fail"};
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    String? userid;
    if (data == null) {
      userid = AuthProvider.authUser.getuserID;
    } else {
      userid = data as String;
    }
    if (userid == null) {
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/yogaman.json'),
          const Text('Oh Snap! Something went wrong'),
          TextButton(onPressed: () {}, child: const Text('Reload'))
        ],
      ));
    }

    return userid != null
        ? Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.arrow_back_ios),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (_) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .Logout()
                        .then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Logout'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: LayoutBuilder(builder: (ctx, constraint) {
              return SafeArea(
                  child: FutureBuilder(
                future: fetchFeeds(userid!),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data as Map<String, dynamic>;
                    if (data['message'] == 'fail') {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/yogaman.json'),
                          const Text('Oh Snap! Something went wrong'),
                          TextButton(
                              onPressed: () {}, child: const Text('Reload'))
                        ],
                      ));
                    }
                    var feedList = data["data"] as List<FeedModel>;
                    var username = data["username"] as String;
                    var image = data["image"] as String;
                    return Column(
                      children: [
                        SizedBox(
                          height: constraint.maxHeight * 0.4,
                          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: ProfileCard(
                            name: username,
                            image: image,
                          ),
                        ),
                        Expanded(
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
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset('assets/lottie/yogaman.json'),
                        ),
                        const Text(
                          "Do not run! We are your friends!",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    );
                  }
                })),
              ));
            }))
        : const Text('no id');
  }
}
