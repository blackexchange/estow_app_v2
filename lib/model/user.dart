import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User extends Model{
  String accessToken;
  String tokenType;
  int expiresIn;
  User user;
  String name;
  String email;

  bool isLoading = false;

  String baseUrl = "http://frozen-mountain-01021.herokuapp.com/api";


  User({this.accessToken, this.tokenType, this.expiresIn, this.user, this.name});

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    name = json['user']["name"];
 //   email = json['user']["email"];
    //user = json['user'] != null ? new User.fromJson({ "name":"as", "email":"asds"}) : null;
   // user  = new User.fromJson({ "name":"as", "email":"asds"}) ;

    print (name);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }


  isLoggedIn() {
    //print (" 9---${userData["name"]}");
    return user!= null;
    //return firebaseUser != null;
  }
  String toString (){
    return "Usuário(Token: $accessToken, User:$user)";
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async{

    isLoading = true;
    notifyListeners();

    var _headers = {"Content-type" : "application/json"};
    Map params = {
      "email": userData["email"],
      "password": pass,
      "name":userData["name"],

    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var _body = json.encode(params);
    var url = "$baseUrl/auth/register";
    http.post(url, body: _body, headers: _headers).
    then((response) async {

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        user = User.fromJson(mapResponse);

        onSuccess();
        sharedPreferences.setString("token", user.accessToken);
        sharedPreferences.setString("user", user.name);

        await _loadCurrentUser();
      }else
        onFail();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
        @required String pass,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail}) async {

    isLoading = true;
    notifyListeners();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _headers = {"Content-type" : "application/json"};
    Map params = {
      "email": email,
      "password": pass
    };

    var _body = json.encode(params);
    var url = "$baseUrl/auth/login";
    http.post(url, body: _body, headers: _headers).
      then((response) async {

        Map mapResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          user = User.fromJson(mapResponse);

          onSuccess();
          sharedPreferences.setString("token", user.accessToken);
          sharedPreferences.setString("user", user.name);

          await _loadCurrentUser();
        }else
          onFail();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async{
    user = null;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.remove("user");
    sharedPreferences.remove("token");
    //userData = json.decode(response.body);
  }

  void recoverPass(String email){

  }

  Future<Null> _loadCurrentUser() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //user.name = sharedPreferences.get("name");
    user.accessToken = sharedPreferences.get("token");
   // print (user.accessToken);

    /*if(user == null)
      user = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
        await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }*/
    notifyListeners();


  }


}

