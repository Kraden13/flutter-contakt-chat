import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  final String title;

  const Header(this.title);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.only(top: 50),
            width: 300,
            height: 300,
            child: Column(children: [
              SvgPicture.asset(
                'assets/undraw_hologram_fjwp.svg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 30),
              ),
            ])));
  }
}
