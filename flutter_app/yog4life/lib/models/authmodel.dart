class AuthModel {
  String mobileNo = '';
  String token = '';
  String name = '';
  String message = '';
  String userId = '';
  String profilePIC = '';

  set setMobileNo(mobileNo) {
    this.mobileNo = mobileNo;
  }

  set setprofilePIC(profilePic) {
    this.profilePIC = profilePic;
  }

  get getProfilePIC {
    return profilePIC;
  }

  get getMobileNo {
    return mobileNo;
  }

  set setToken(token) {
    this.token = token;
  }

  get gettoken {
    return token;
  }

  set setname(name) {
    this.name = name;
  }

  get getname {
    return name;
  }

  set setuserid(userId) {
    this.userId = userId;
  }

  String get getuserID {
    return userId;
  }
}
