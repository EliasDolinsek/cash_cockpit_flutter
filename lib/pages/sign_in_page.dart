import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/auth_manager.dart' as authManager;

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "CashCockpit",
                    style: TextStyle(fontSize: 48),
                  ),
                  SignInPageTextsAnimation(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: BlocBuilder(
              bloc: BlocProvider.of<AuthBloc>(context),
              builder: (context, state){
                if(state is SigningInAuthState){
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            "SIGN IN WITH GOOGLE",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            BlocProvider.of<AuthBloc>(context).dispatch(SignInWithGoogleEvent());
                          },
                        ),
                      ),
                      SizedBox(
                        child: OutlineButton(
                          onPressed: () {},
                          child: Text("SIGN IN WITH EMAIL"),
                        ),
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SignInPageTextsAnimation extends StatefulWidget {
  @override
  _SignInPageTextsAnimationState createState() =>
      _SignInPageTextsAnimationState();
}

class _SignInPageTextsAnimationState extends State<SignInPageTextsAnimation>
    with SingleTickerProviderStateMixin {
  static const texts = [
    "EASY FINACE MANAGEMENT",
    "FAST FINACE MANAGEMENT",
    "JUST ADD A BILL",
    "SPECIFIE THE AMOUNT",
    "SELECT A CATEGORY",
    "SET A NAME",
    "ADD IMAGES",
    "AND GO"
  ];
  int _currentTextIndex = 0;

  AnimationController animationController;
  Animation opacityAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(animationController);

    opacityAnimation.addStatusListener((AnimationStatus status) {
      if (_currentTextIndex + 1 != texts.length) {
        if (status == AnimationStatus.completed) {
          _currentTextIndex++;
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward(from: 0);
        }
      }
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: opacityAnimation,
      builder: (context, widget) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Text(texts.elementAt(_currentTextIndex)),
        );
      },
    );
  }
}
