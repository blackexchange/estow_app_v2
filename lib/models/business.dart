// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Business businessFromJson(String str) => Business.fromJson(json.decode(str));

String businessToJson(Business data) => json.encode(data.toJson());

class Business extends Model{
  Business({
    this.companies,
  });

  List<Company> companies;

  String baseUrl = GlobalConfiguration().getString('base_url');

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    companies: List<Company>.from(json["Companies"].map((x) => Company.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Companies": List<dynamic>.from(companies.map((x) => x.toJson())),
  };

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadBusiness();
  }
  Future <Business> _loadBusiness() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var _headers = {"Content-type" : "application/json", "Authorization" : "Bearer $token"};
    Map params = {
      "query":'query{Companies(include_inactive: true){'
          'id, name, cnpj, users{id, email}}}'
    };
    var _body = json.encode(params);

    http.post(baseUrl, body: _body, headers: _headers).
    then((response) async {
      print(response.body);
      Map mapResponse = json.decode(response.body)["data"];
      if (response.statusCode == 200)
        print (mapResponse);
        //business = Business.fromJson(mapResponse);

    });


  }


}

class Company {
  Company({
    this.id,
    this.name,
    this.cnpj,
    this.businessType,
    this.users,
    this.units,
  });

  int id;
  String name;
  String cnpj;
  BusinessType businessType;
  List<User> users;
  List<Unit> units;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    cnpj: json["cnpj"],
   // businessType: BusinessType.fromJson(json["business_type"]),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    units: List<Unit>.from(json["units"].map((x) => Unit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cnpj": cnpj,
    "business_type": businessType.toJson(),
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "units": List<dynamic>.from(units.map((x) => x.toJson())),
  };
}

class BusinessType {
  BusinessType({
    this.id,
    this.name,
    this.unitTypes,
    this.roleTypes,
  });

  int id;
  String name;
  List<UnitType> unitTypes;
  List<RoleType> roleTypes;

  factory BusinessType.fromJson(Map<String, dynamic> json) => BusinessType(
    id: json["id"],
    name: json["name"],
    unitTypes: List<UnitType>.from(json["unit_types"].map((x) => UnitType.fromJson(x))),
    roleTypes: List<RoleType>.from(json["role_types"].map((x) => RoleType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "unit_types": List<dynamic>.from(unitTypes.map((x) => x.toJson())),
    "role_types": List<dynamic>.from(roleTypes.map((x) => x.toJson())),
  };
}

class RoleType {
  RoleType({
    this.id,
    this.name,
    this.abbreviation,
  });

  int id;
  RoleTypeName name;
  Abbreviation abbreviation;

  factory RoleType.fromJson(Map<String, dynamic> json) => RoleType(
    id: json["id"],
    name: roleTypeNameValues.map[json["name"]],
    abbreviation: abbreviationValues.map[json["abbreviation"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": roleTypeNameValues.reverse[name],
    "abbreviation": abbreviationValues.reverse[abbreviation],
  };
}

enum Abbreviation { ENF, MED, TEC }

final abbreviationValues = EnumValues({
  "ENF": Abbreviation.ENF,
  "MED": Abbreviation.MED,
  "TEC": Abbreviation.TEC
});

enum RoleTypeName { ENFERMEIRO, MDICO, TCNICO }

final roleTypeNameValues = EnumValues({
  "Enfermeiro": RoleTypeName.ENFERMEIRO,
  "Médico": RoleTypeName.MDICO,
  "Técnico": RoleTypeName.TCNICO
});

class UnitType {
  UnitType({
    this.id,
    this.name,
    this.metric,
  });

  int id;
  UnitTypeName name;
  Metric metric;

  factory UnitType.fromJson(Map<String, dynamic> json) => UnitType(
    id: json["id"],
    name: unitTypeNameValues.map[json["name"]],
    metric: metricValues.map[json["metric"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": unitTypeNameValues.reverse[name],
    "metric": metricValues.reverse[metric],
  };
}

enum Metric { SALAS, PACIENTES }

final metricValues = EnumValues({
  "pacientes": Metric.PACIENTES,
  "salas": Metric.SALAS
});

enum UnitTypeName { CENTRO_CIRRGICO, UNIDADE_DE_CUIDADOS_INTENSIVOS }

final unitTypeNameValues = EnumValues({
  "Centro Cirúrgico": UnitTypeName.CENTRO_CIRRGICO,
  "Unidade de Cuidados Intensivos": UnitTypeName.UNIDADE_DE_CUIDADOS_INTENSIVOS
});

class User {
  User({
    this.id,
    this.email,
  });

  int id;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }


}
class Unit {
  Unit({
    this.id,
    this.name,
    this.quantity,
    this.metric,
  });

  int id;
  String name;
  int quantity;
  String metric;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    name: json["name"],
    quantity: json["quantity"],
    metric: json["metric"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "metric": metric,
  };
}
