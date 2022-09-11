import 'package:flutter/material.dart';
import 'package:yog4life/provider/feedaddprovider.dart';
import 'package:yog4life/util/utility.dart';
import 'package:yog4life/widget/bottomimagelist.dart';
import 'package:yog4life/widget/feedaddform.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FeedAddScreen extends StatelessWidget {
  static const routeName = '/feedadd';
  TextEditingController postText = TextEditingController();
  bool isLoading = false;

  void showLoadingIndicator(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              title: Text(text),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget showBody(BuildContext context) {
    return Column(children: [
      Expanded(
        child: FeedAddForm(postTextController: postText),
      ),
      BottomImageList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // print(files);
    final feedaddprv = Provider.of<FeedAddprovider>(context, listen: false);
    return WillPopScope(
      onWillPop: () => feedaddprv.showExitPopup(context),
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => feedaddprv.showExitPopup(context),
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
                    onPressed: () {
                      showLoadingIndicator(
                          "Your time is very important to us. Please wait while we ignore you.😜",
                          context);
                      feedaddprv.checkPostData(postText).then((value) {
                        Navigator.of(context).pop();
                        if (value == "success") {
                          Navigator.of(context).pop("true");
                        } else if (value == "text") {
                          Utility.showSnackbar(context,
                              "Add some awesome captions to your post");
                        } else if (value == "image") {
                          Utility.showSnackbar(
                              context, "Add some awesome images to your post");
                        } else {
                          Utility.showSnackbar(context, "Something went wrong");
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        fixedSize: const Size(130, 40),
                        backgroundColor: Theme.of(context).primaryColor),
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
            future: feedaddprv.requestPermission(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return showBody(context);
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  );
                }
              } else {
                return const CircularProgressIndicator(
                  color: Colors.black,
                );
              }
            },
          )),
    );
  }
}
