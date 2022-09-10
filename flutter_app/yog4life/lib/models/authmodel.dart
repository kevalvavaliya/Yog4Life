class AuthModel {
  String mobileNo = '';
  String token = '';
  String name = '';
  String message = '';

  set setMobileNo(mobileNo) {
    this.mobileNo = mobileNo;
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
}
