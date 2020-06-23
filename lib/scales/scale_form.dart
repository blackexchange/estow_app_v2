import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estow_app/scales/models/scale.dart';

//import 'package:scoped_model/scoped_model.dart';

class ScaleForm extends StatefulWidget {
  @override
  _ScaleFormState createState() => _ScaleFormState();
}

class _ScaleFormState extends State<ScaleForm> {

  final _nameController = TextEditingController();
  final _vigenciaController = TextEditingController();
  final _regimeController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Escala"),
          centerTitle: true,
        ),
        body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: "Nome da Escala"
                    ),
                    validator: (text){
                      if(text.isEmpty) return "Nome Inválido!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _vigenciaController,
                    decoration: InputDecoration(
                        hintText: "Data Vigência"
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (text){
                      if(text.isEmpty ) return "Data inválida!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _regimeController,
                    decoration: InputDecoration(
                        hintText: "Regime"
                    ),
                    validator: (text){
                      if(text.isEmpty ) return "Regime inválido!";
                    },
                  ),

                  SizedBox(height: 16.0,),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Criar Escala",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){

                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "vigencia": _vigenciaController.text,
                            "regime": _regimeController.text
                          };
/*
                          model.signUp(
                              userData: userData,
                              onSuccess: _onSuccess,
                              onFail: _onFail
                          );*/
                        }
                      },
                    ),
                  ),
                ],
              ),
            )

    );

  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Operação realizada com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha na operação!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

}

