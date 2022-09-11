import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../widget/showImage.dart';
import '../provider/feedaddprovider.dart';

class BottomImageList extends StatefulWidget {
  @override
  State<BottomImageList> createState() => _BottomImageListState();
}

class _BottomImageListState extends State<BottomImageList>
    with SingleTickerProviderStateMixin {
  Future<List> imagesList = Directory("/storage/emulated/0/DCIM/Camera")
      .list(recursive: false, followLinks: false)
      .toList();

  @override
  Widget build(BuildContext context) {
    final prv = Provider.of<FeedAddprovider>(context, listen: false);

    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      heightFactor: Provider.of<FeedAddprovider>(context).getVisiblityStatus()
          ? 1.0
          : 0.0,
      child: Container(
        height: 150,
        child: FutureBuilder(
            future: imagesList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List a = snapshot.data as List;
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: prv.getImageFromCamera,
                        child: ShowImage(
                            child: const Icon(Icons.camera_alt_rounded)),
                      );
                    } else if (index == 9) {
                      return GestureDetector(
                          onTap: prv.getImageFromGallery,
                          child: ShowImage(
                            child: const Icon(Icons.photo),
                          ));
                    } else {
                      precacheImage(FileImage(a[index]), context);
                      return GestureDetector(
                        child: ShowImage(
                          child: Image.file(
                            a[index],
                            fit: BoxFit.fill,
                            cacheHeight: 150,
                          ),
                        ),
                        onTap: () {
                          prv.toogleVisiblity();
                          prv.setImagepath(a[index]);
                        },
                      );
                    }
                  }),
                  itemCount: 10,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              }
            }),
      ),
    );
  }
}
