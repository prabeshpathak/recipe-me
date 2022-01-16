import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/pages/SignUp.dart';
import 'SignInPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _controller1;
  late Animation<Offset> _offsetAnimation1;

  @override
  void initState() {
    super.initState();

    //controller1
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

// offset1
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    //controller2
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.elasticInOut,
    ));

    _controller.forward();
    _controller1.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.blue.shade300,
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              child: SlideTransition(
                position: _offsetAnimation,
                child: Text(
                  "Great Recipes",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 6),
                  Text(
                    "For the best people",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  boxContainer(
                      "assets/google.png", "Sign up with Google", null),
                  SizedBox(
                    height: 15,
                  ),
                  boxContainer(
                      "assets/facebook1.png", "Sign up with Facebook", null),
                  SizedBox(
                    height: 15,
                  ),
                  boxContainer(
                      "assets/email2.png", "Sign up with Email", onEmailClick),
                  SizedBox(height: 20),
                  SlideTransition(
                    position: _offsetAnimation1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ));
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }

  Widget boxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: _offsetAnimation1,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 65,
          width: MediaQuery.of(context).size.width - 140,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Row(
                children: [
                  Image.asset(path, width: 25, height: 25),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
