import 'package:aplicacion_final_app/components/loader_component.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:aplicacion_final_app/helpers/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //String _email = '';
  //String _emailError = '';
  //bool _emailShowError = false;

  //String _password = '';
  //String _passwordError = '';
  //bool _passwordShowError = false;

  bool _showLoader = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50,),
                _showLogo(),
                SizedBox(height: 20,),
                _showButtons(),
              ],
            ),
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...') : Container(),
        ],
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/vehicles_logo.png'),
      width: 300,
      fit: BoxFit.fill,
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //_showLoginButton(),
              SizedBox(width: 20,),
              //_showRegisterButton(),
            ],
          ),
          _showFacebookLoginButton(),
        ],
      ),
    );
  }

  Widget _showFacebookLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _loginFacebook(), 
            icon: FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ), 
            label: Text('Iniciar sesión con Facebook'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF3B5998),
              onPrimary: Colors.white
            )
          )
        )
      ],
    );
  }

  void _loginFacebook() async {
    await FacebookAuth.i.login();
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture.width(800).heigth(800), first_name, last_name",
      );
      print(requestData);
    }
  }

}