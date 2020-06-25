import 'dart:convert';
import 'package:estow_app/business/models/business.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessModel extends Model{
  String accessToken;

  //BusinessModel business;
  String name;
  int id;
  Map users;
  String cnpj;
  int business_type;

  BusinessModel business;


  static List<BusinessModel> businessList = <BusinessModel>[
    BusinessModel(
  id: 1, name: 'Badu', cnpj:"123123123"
  ),BusinessModel(
        id: 2, name: 'Miramar', cnpj:"123123123"
    ),BusinessModel(
        id: 2, name: 'Senta', cnpj:"123123123"
    ),];

  bool isLoading = false;

  String baseUrl = "http://frozen-mountain-01021.herokuapp.com/graphql";

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    fetchAll();
  }

  BusinessModel({this.id, this.name, this.cnpj});

  BusinessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json["name"];
    cnpj = json["cnpj"];

  }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data["Company"]['id'] = this.id;
      data["Company"]['name'] = this.name;
      data["Company"]['cnpj'] = this.cnpj;
      return data;
    }


    String toString (){
      return "Business(Id: $id, Nome:$name)";
    }

    Future<BusinessModel> getBusiness(int id) async {


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};


    Map params = {
      "query":'query{Company(id: $id){'
          'id, name, cnpj}}'
    };
    var _body = json.encode(params);
    var baseUrl = "http://frozen-mountain-01021.herokuapp.com/graphql";

    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200)
        return BusinessModel.fromJson(mapResponse["data"]["Company"]);
      else
        return null;

    }).catchError((e){
      print ("ESTOW $e");
    });

  }

  Future <bool> fetchAll() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};
    Map params = {
      "query":'query{Companies(include_inactive: true)'
          '{id, name, cnpj}'
          '}'
    };



    var _body = json.encode(params);
    String baseUrl = "http://frozen-mountain-01021.herokuapp.com/graphql";

    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {
      Map mapResponse = json.decode(response.body);
      if (response.statusCode == 200){
//        var businessArr = new List<BusinessModel>();

        //businessList = BusinessModel.fromJson(model);
        return businessList != null;

      }else
         return null;
    });

  }



}

