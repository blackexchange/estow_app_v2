// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario extends Model{
  Usuario({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  String accessToken;
  String tokenType;
  int expiresIn;
  User user;

  Usuario currentUser;
  bool isLoading = false;

  String baseUrl = GlobalConfiguration().getString('api_base_url');

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }


  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "user": user.toJson(),
  };


  isLoggedIn() {
    return currentUser != null;
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
   //    sharedPreferences.setString("token", user.accessToken);
       // sharedPreferences.setString("user", user.name);

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

  Future<Null> _loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (currentUser == null) {
      currentUser = Usuario.fromJson(json.decode(prefs.get("data_user")));
    }
    print ("TOKEN ${currentUser.accessToken}");
    notifyListeners();
  }

  void recoverPass(String email){

  }

  void signIn ({@required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail}) async {

    final String url = '${baseUrl}login';

    isLoading = true;
    notifyListeners();

    final client = new http.Client();

    Map userMap = {
      "email": email,
      "password": pass
    };
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userMap),
    );
    print(response.body);

    if (response.statusCode == 200) {
      onSuccess();
      setCurrentUser(response.body);
    }else{
      onFail();
    }
    isLoading = false;
    notifyListeners();
    //return currentUser.value;
  }

  void signOut() async{
    currentUser = null;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("data_user");
    sharedPreferences.remove("token");

  }

  void setCurrentUser(jsonString) async {

    if (json.decode(jsonString) != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map mapData = jsonDecode(jsonString);
      currentUser = Usuario.fromJson(mapData);
      await prefs.setString('data_user', json.encode(currentUser.toJson()));
      await prefs.setString('token', currentUser.accessToken);

    }
    notifyListeners();
  }

}

class User {
  User({
    this.id,
    this.name,
    this.email,
  });

  int id;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };

}
