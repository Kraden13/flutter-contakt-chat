import 'package:chat_contakt/helpers/show_alert.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:chat_contakt/widgets/custom_input.dart';
import 'package:chat_contakt/widgets/green_button.dart';
import 'package:chat_contakt/widgets/header.dart';
import 'package:chat_contakt/widgets/labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
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
                  Header('Registro'),
                  _Form(),
                  Labels('login', '¿Ya tienes cuenta?', 'Ingresar ahora'),
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
  final nameCntrl = new TextEditingController();
  final emailCntrl = new TextEditingController();
  final passwordCntrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            name: 'Nombre',
            icon: Icons.perm_identity,
            controller: nameCntrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            name: 'Email',
            icon: Icons.email,
            controller: emailCntrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            name: 'Password',
            icon: Icons.lock_outline,
            controller: passwordCntrl,
            isPassword: true,
          ),
          GreenButton(
              'Nuevo Registro',
              authService.auth
                  ? null
                  : () async {
                      final registerOk = await authService.register(
                          nameCntrl.text.trim(),
                          emailCntrl.text.trim(),
                          passwordCntrl.text.trim());

                      if (registerOk) {
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        showAlert(context, 'Registro Incorrecto', registerOk);
                      }
                    }),
        ],
      ),
    );
  }
}
