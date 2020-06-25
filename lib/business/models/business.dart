import 'dart:convert';
import 'package:estow_app/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Business extends Model {
  Business({
    this.name = '',
    this.imagePath = '',
    this.cnpj = '',
    this.businessType = 0,
    this.rating = 0.0,
    this.countMembers = 0,
  });

  String name;
  String cnpj;
  int businessType;
  double rating;
  String imagePath;
  int countMembers;

  User user;



  bool isLoading = false;

  String baseUrl = "http://frozen-mountain-01021.herokuapp.com/graphql";
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    businessTypeList();
  }
  static List<Business> businessList = <Business>[
    Business(
      imagePath: 'assets/design_course/interFace1.png',
      name: 'Labchecap',
      countMembers: 24,
      businessType: 25,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace2.png',
      name: 'Labchecap',
      countMembers: 24,
      businessType: 25,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace3.png',
      name: 'Labchecap',
      countMembers: 24,
      businessType: 25,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace4.png',
      name: 'Labchecap',
      countMembers: 24,
      businessType: 25,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),

  ];

  static List<Business> popularBusinessList = <Business>[
    Business(
      imagePath: 'assets/design_course/interFace1.png',
      name: 'Labchecap',
      countMembers: 24,
      businessType: 25,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace2.png',
      name: 'DNA',
      countMembers: 4,
      businessType: 1,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace3.png',
      name: 'Albert Einstein',
      countMembers: 24,
      businessType: 1,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
    Business(
      imagePath: 'assets/design_course/interFace4.png',
      name: 'São Miguel',
      countMembers: 2,
      businessType: 2,
      cnpj: '11.000.111/000-01',
      rating: 4.3,
    ),
  ];

  Future <List> businessTypeList() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};
    Map params = {
      "query":'BusinessTypes{'
          'id,name}'
    };
    var _body = json.encode(params);

    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {
print(response.body);
      Map mapResponse = json.decode(response.body);
      if (response.statusCode == 200)
          return mapResponse;
      });
    return null;

  }

  void add({@required Map<String, dynamic> businessData,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async {

    isLoading = true;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var token = sharedPreferences.get("token");

    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};
    Map params = {
      "query":'mutation{NewCompany('
          'name: "${businessData['name']}",'
          'cnpj: "${businessData['cnpj']}",'
          'business_type_id: ${businessData['businessType']}'
          '){name}}'
    };
    var _body = json.encode(params);
    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {


      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {

        onSuccess();

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

  void sendInvite(String email) async {

    isLoading = true;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");

    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};
    Map params = {
      "query":'mutation{InviteForCompany('
          'id: id,'
          'email: "$email",'
          'include: true}'
          '){id, email}}'
    };

    print (_headers);
    var _body = json.encode(params);
    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {


      Map mapResponse = json.decode(response.body);
print (mapResponse);
      if (response.statusCode == 200) {

        //onSuccess();

      }else
       // onFail();

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
     // onFail();
      isLoading = false;
      notifyListeners();
    });
  }

}
