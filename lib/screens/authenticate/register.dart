import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register to Brew Crew'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    color: Colors.pink[400],
                    onPressed: () async{
                      if(_formKey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            loading = false;
                            error = 'Please suply valide credencials';
                          });
                        }
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),

                  )

                ],
              ),
            )
        ),
      ),
    );
  }
}
