import 'package:flutter/material.dart';

class GreenButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  GreenButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            this.text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ))),
      elevation: 2,
      highlightElevation: 5,
      color: Color(0xffAFEA97),
      shape: StadiumBorder(),
      onPressed: this.onPressed,
    );
  }
}
