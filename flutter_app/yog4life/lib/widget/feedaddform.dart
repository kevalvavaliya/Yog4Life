import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../provider/feedaddprovider.dart';
import '../provider/authprovider.dart';

class FeedAddForm extends StatelessWidget {
  TextEditingController postTextController;
  FeedAddForm({required this.postTextController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(AuthProvider.authUser.getProfilePIC),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  FittedBox(
                    child: Text(
                      "posting as @${AuthProvider.authUser.getname.toString()}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Rubik',
                          color: Colors.black45),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: postTextController,
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
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 470, maxWidth: double.infinity),
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Consumer<FeedAddprovider>(
                          builder: (context, value, child) {
                            if (value.getImagepath() != null) {
                              return Stack(children: [
                                Image.file(
                                  value.getImagepath() as File,
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: (() {
                                      Provider.of<FeedAddprovider>(context,
                                              listen: false)
                                          .toogleVisiblity();

                                      Provider.of<FeedAddprovider>(context,
                                              listen: false)
                                          .setImagepath(null);
                                    }),
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.amber,
                                      ),
                                      height: 30,
                                      width: 30,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ]);
                            } else {
                              return Container();
                            }
                          },
                        )),
                  )
                ]),
          )),
        ],
      ),
    );
  }
}
