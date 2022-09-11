class FeedModel {
  String username;
  String postImage;
  String postDescription;
  String userId;
  String profileImage;

  FeedModel({
    required this.username,
    required this.postImage,
    required this.postDescription,
    required this.userId,
    required this.profileImage,
  });

  String get getUsername => username;
  String get getPostImage => postImage;
  String get getPostDescription => postDescription;
  String get getUserID => userId;
  String get getProfileImage => profileImage;
}
