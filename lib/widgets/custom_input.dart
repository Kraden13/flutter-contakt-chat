import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String name;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  CustomInput(
      {@required this.name,
      @required this.icon,
      @required this.controller,
      this.isPassword = false,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 5,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: TextField(
          obscureText: this.isPassword,
          controller: this.controller,
          autocorrect: false,
          keyboardType: this.keyboardType,
          // obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: this.name,
          ),
        ));
  }
}
