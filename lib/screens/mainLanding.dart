import 'package:recipe_app_flutter/utils/exportRoutes.dart';
import 'package:flutter/material.dart';

// Landing page class that extends stateless widget because it won't change itself.
// Think back to static vs. nonstatic in Java.
class Landing extends StatelessWidget {
  // Builds the center container used to hold the text and buttons of the landing.
  Widget _buildCenter(context) {
    // The Center class forces middle horizontal alignment.
    return Center(
        child: Container(
      width: 370,
      height: 320,
      padding: EdgeInsets.all(15.0),
      // Decoration to add a rounded corner to the container.
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // Column class to allow the cildren to be horizontally and veritcally centered.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Recipe Me',
            style: TextStyle(
                fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
          ),

          // Sized boxes make for readable spacing.
          SizedBox(height: 5),
          Text('Share Your Happy Meal',
              style: TextStyle(fontSize: 26, color: Colors.black)),
          SizedBox(height: 15),
          // Row classes to allow the button to fill the entire horizontal width.
          Row(
            children: <Widget>[
              // The expanded class is what lets the button fill the width.
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:
                      // Use the secondary theme color for this button.
                      Colors.black, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  // Navigate to the login screen.
                  Navigator.pushNamed(context, RouteName.LOGIN);
                },
                child: Text('Log in'),
              ))
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  // Navigate to the signup screen.
                  Navigator.pushNamed(context, RouteName.SIGNUP);
                },
                child: Text('Sign up'),
                style: ElevatedButton.styleFrom(
                  primary:
                      // Use the secondary theme color for this button.
                      Colors.black, // background
                  onPrimary: Colors.white, // foreground
                ),
              ))
            ],
          ),
        ],
      ),
    ));
  }

  // This function is called to build the actual widget itself.
  @override
  Widget build(BuildContext context) {
    // Always wrap screens in a safe area and a scaffold. The safearea prevents
    // parts of the screen getting clipped from the shape of the device,
    // and the scaffold allows for use of objects such as drawers.
    return SafeArea(
        child: Scaffold(
            body: Container(
                // Background image. I'm a bit annoyed how each screen reloads it.
                // Bounty for whoever can fix that.
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/BackgroundBlurred.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildCenter(context),
                  ],
                ))));
  }
}
