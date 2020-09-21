import 'package:chat_contakt/widgets/custom_input.dart';
import 'package:chat_contakt/widgets/green_button.dart';
import 'package:chat_contakt/widgets/header.dart';
import 'package:chat_contakt/widgets/labels.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header('Contakt Chat'),
                  _Form(),
                  Labels(
                      'register', '¿Aún no tienes cuenta?', 'Crea una ahora'),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCntrl = new TextEditingController();
  final passwordCntrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            name: 'email',
            icon: Icons.perm_identity,
            controller: emailCntrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            name: 'password',
            icon: Icons.email,
            controller: passwordCntrl,
            isPassword: true,
          ),
          GreenButton('Ingresar', () {}),
        ],
      ),
    );
  }
}
