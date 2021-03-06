import 'package:flutter/material.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/auth_screen.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/utilities/color.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  
  bool isConn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      drawer: CustomDrawer(isConn: isConn),
      body: Stack(
            clipBehavior: Clip.none,
        children: [
          CAppBarWidget(title: "Authentification", isConn: isConn),
          const Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: AuthScreen(),
          )
        ]
      )
    );
  }

  
}


