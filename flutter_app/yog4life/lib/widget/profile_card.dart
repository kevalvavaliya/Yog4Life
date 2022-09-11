import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileCard extends StatelessWidget {
  String name;
  String image;

  ProfileCard({required this.name, required this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight * 0.4,
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(children: [
              const SizedBox(
                height: 26,
              ),
              SizedBox(
                width: constraints.maxWidth * 0.35,
                height: constraints.maxWidth * 0.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: SizedBox(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxWidth * 0.3,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                name,
                style: Theme.of(context).textTheme.headline3,
              ),
            ]),
          ),
        ),
      );
    });
  }
}


// CachedNetworkImage(
//                       imageUrl:
//                           "https://bafkreicjo6zax54qsdxsninu4fzjkl3ieihbhfn4pdpd3vjad7wuan3r5i.ipfs.dweb.link",
//                       fit: BoxFit.cover,
//                       progressIndicatorBuilder:
//                           (context, url, downloadProgress) => Center(
//                         child: SizedBox(
//                           width: constraints.maxWidth * 0.1,
//                           height: constraints.maxWidth * 0.1,
//                           child: CircularProgressIndicator(
//                               value: downloadProgress.progress),
//                         ),
//                       ),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                     ),



// return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           width: constraints.maxWidth,
//           height: constraints.maxHeight * 0.4,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: constraints.maxWidth * 0.42,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: 
//                   ),
//                 ),
//                 const Spacer(flex: 2),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       '8',
//                       style: Theme.of(context).textTheme.headline5,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       'Posts',
//                       style: Theme.of(context).textTheme.subtitle1,
//                     ),
//                     const SizedBox(height: 50),
//                   ],
//                 ),
//                 const Spacer(flex: 1),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.edit_outlined,
//                     size: 26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );