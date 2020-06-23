import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estow_app/business/models/business.dart';
import 'package:scoped_model/scoped_model.dart';

class BusinessForm extends StatefulWidget {
  @override
  _BusinessFormState createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Empresa"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<Business>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Nome da Empresa"),
                  validator: (text) {
                    if (text.isEmpty) return "Nome Inválido!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _cnpjController,
                  decoration: InputDecoration(hintText: "CNPJ"),
                  validator: (text) {
                    if (text.isEmpty) return "CNPJ inválido!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _businessTypeController,
                  decoration: InputDecoration(hintText: "Tipo da Empresa"),
                  validator: (text) {
                    if (text.isEmpty) return "Tipo inválido!";
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> _businessData = {
                          "name": _nameController.text,
                          "cnpj": _cnpjController.text,
                          "businessType": _businessTypeController.text
                        };

                        model.add(
                            businessData: _businessData,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Operação realizada com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha na operação!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
