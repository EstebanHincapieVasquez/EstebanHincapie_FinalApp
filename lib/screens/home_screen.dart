import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:aplicacion_final_app/components/loader_component.dart';
import 'package:aplicacion_final_app/helpers/api_helper.dart';
import 'package:aplicacion_final_app/helpers/constants.dart';
import 'package:aplicacion_final_app/models/finals.dart';
import 'package:aplicacion_final_app/models/response.dart';
import 'package:aplicacion_final_app/models/token.dart';
import 'package:aplicacion_final_app/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {

  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _showLoader = false;
  late Finals _finals = Finals(id: 0, date: '0001-01-01T00:00:00', email: '', qualification: 0, theBest: '', theWorst: '', remarks: '');

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  int _qualification = 0;
  String _qualificationError = '';
  bool _qualificationShowError = false;
  double _initialRating = 0;

  String _theBest = '';
  String _theBestError = '';
  bool _theBestShowError = false;
  TextEditingController _theBestController = TextEditingController();

  String _theWorst = '';
  String _theWorstError = '';
  bool _theWorstShowError = false;
  TextEditingController _theWorstController = TextEditingController();

  String _remarks = '';
  String _remarksError = '';
  bool _remarksShowError = false;
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getEncuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        title: Text('Examen - Final - App - Encuesta Curso'),
      ),
      body: Center(
        child: _showLoader 
          ? LoaderComponent(text: 'Por favor espere...',) 
          : _formulario(),
      ),
    );
  }

  Widget _formulario() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: widget.token.user.imageFullPath,
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                height: 200,
                width: 200,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              )
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                'Bienvenid@ ${widget.token.user.fullName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10,),
            _showEmail(),
            _showTheBest(),
            _showTheWorst(),
            _showRemarks(),
            _showTextQualificate(),
            _showQualification(),
            _showButtons(),
            _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
          ],
        ),
      )
    );
  }

   Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa email...',
          labelText: 'Ingresa correo electrónico',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showTextQualificate(){
    return Center(
      child: Text(_qualificationShowError == false ? 'Califica el curso' : _qualificationError,
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _qualificationShowError == false ? Colors.black : Colors.red
        ),
      ),
    );
  }

  Widget _showQualification() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[  
        RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.blue.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.blue,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _qualification = rating.toInt();
            });
          },
          updateOnDrag: true,
        ),
      ],
    );
  }

  Widget _showTheBest() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _theBestController,
        decoration: InputDecoration(
          hintText: 'Qué fue lo que más te gustó del curso...',
          labelText: 'Ingresa lo mejor del curso',
          errorText: _theBestShowError ? _theBestError : null,
          suffixIcon: Icon(Icons.comment),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theBest = value;
        },
      ),
    );
  }

  Widget _showTheWorst() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _theWorstController,
        decoration: InputDecoration(
          hintText: 'Qué fue lo que menos te gustó del curso...',
          labelText: 'Ingresa lo peor del curso',
          errorText: _theWorstShowError ? _theWorstError : null,
          suffixIcon: Icon(Icons.comment),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _theWorst = value;
        },
      ),
    );
  }

  Widget _showRemarks() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _remarksController,
        decoration: InputDecoration(
          hintText: 'Qué recomendas para hacer un mejor curso...',
          labelText: 'Ingresa comentarios generales',
          errorText: _remarksShowError ? _remarksError : null,
          suffixIcon: Icon(Icons.comment),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _remarks = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showRegisterButton(),
        ],
      ),
    );
  }

 Widget _showRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Registrar Encuesta'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xFF120E43);
          }),
        ),
        onPressed: () => _register(),
      ),
    );
  }

  void _register() async {
    if (!_validateFields()) {
      return;
    }
    _addRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email.';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email válido.';
    } else if (!_email.toLowerCase().endsWith('@correo.itm.edu.co')){
      _emailShowError = true;
      _emailError = 'Debe ser un email del ITM.';
    } else {
      _emailShowError = false;
    }

    if (_theBest.isEmpty) {
      isValid = false;
      _theBestShowError = true;
      _theBestError = 'Debes ingresar un comentario.';
    } else {
      _theBestShowError = false;
    }

    if (_theWorst.isEmpty) {
      isValid = false;
      _theWorstShowError = true;
      _theWorstError = 'Debes ingresar un comentario.';
    } else {
      _theWorstShowError = false;
    }

    if (_remarks.isEmpty) {
      isValid = false;
      _remarksShowError = true;
      _remarksError = 'Debes ingresar un comentario.';
    } else {
      _remarksShowError = false;
    }

    if (_qualification==0) {
      isValid = false;
      _qualificationShowError = true;
      _qualificationError = 'Debes ingresar una puntuación.';
      _showTextQualificate();
    } else {
      _qualificationShowError = false;
      _showTextQualificate();
    }

    setState(() {});
    return isValid;
  }

  Future<Null> _getEncuesta() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getFinals(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    setState(() {
      _finals = response.result;
    });

    _loadFieldValues();

  }

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'email': _email,
      'qualification': _qualification,
      'theBest': _theBest,
      'theWorst': _theWorst,
      'remarks': _remarks
    };

    Response response = await ApiHelper.post(
      '/api/Finals/', 
      request, 
      widget.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    } else{
      var response =  await showAlertDialog(
      context: context,
      title: 'Confirmación', 
      message: '¿Estas seguro de guardar la encuesta?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'Sí'),
      ]
      ); 
      if (response == 'yes') {
        await showAlertDialog(
          context: context,
          title: 'Encuesta',
          message: 'Encuesta almacenada con éxito.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
      }
    }
  }

  void _loadFieldValues() {
    _email = _finals.email == null ? '' : _finals.email;
    _emailController.text = _email;

    _qualification = _finals.qualification;
    _initialRating = _qualification.toDouble();

    _theBest = _finals.theBest == null ? '' : _finals.theBest;
    _theBestController.text = _theBest;

    _theWorst = _finals.theWorst == null ? '' : _finals.theWorst;
    _theWorstController.text = _theWorst;

    _remarks = _finals.remarks == null ? '' : _finals.remarks;
    _remarksController.text = _remarks; 
  }
  

}