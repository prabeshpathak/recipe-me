import 'package:recipe_app_flutter/screens/home.dart';
import 'package:recipe_app_flutter/screens/landing.dart';
import 'package:recipe_app_flutter/screens/login.dart';
import 'package:recipe_app_flutter/screens/signup.dart';
import 'package:recipe_app_flutter/screens/forgotPassword.dart';
import 'package:recipe_app_flutter/screens/verification.dart';
import 'package:recipe_app_flutter/utils/AuthProvider.dart';
import 'package:recipe_app_flutter/utils/IngredientModel.dart';
import 'package:recipe_app_flutter/utils/UserProvider.dart';
import 'package:recipe_app_flutter/utils/UserPreference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/User.dart';
import 'utils/RouteNames.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(13, 15, 16, .1),
  100: Color.fromRGBO(13, 15, 16, .2),
  200: Color.fromRGBO(13, 15, 16, .3),
  300: Color.fromRGBO(13, 15, 16, .4),
  400: Color.fromRGBO(13, 15, 16, .5),
  500: Color.fromRGBO(13, 15, 16, .6),
  600: Color.fromRGBO(13, 15, 16, .7),
  700: Color.fromRGBO(13, 15, 16, .8),
  800: Color.fromRGBO(13, 15, 16, .9),
  900: Color.fromRGBO(13, 15, 16, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // comment/uncomment this v line depending on if you want to sign in/out on reload
    // UserPreference().removeUser();
    Future<User> getUserData() => UserPreference().getUser();
    MaterialColor colorCustom = MaterialColor(0xFF131516, color);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IngredientModel()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child:
            // MaterialApp is the main app being run. There should only exist one for
            // each project.
            MaterialApp(
                title: 'Recipe-Me',

                // The ThemeData allows our widgets to use default colors. Change this
                // depending on how we want the project to look.
                // theme: ThemeData(
                //   // PrimarySwatch and color mostly deal with how text vs. buttons are colored.
                //   primarySwatch: colorCustom,
                //   primaryColor: Colors.green,
                //   accentColor: Colors.grey,
                // ),
                theme: ThemeData(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    primaryColor: Colors.black,
                    primaryColorBrightness: Brightness.dark,
                    primaryColorLight: Colors.black,
                    brightness: Brightness.dark,
                    primaryColorDark: Colors.black,
                    indicatorColor: Colors.white,
                    canvasColor: Colors.black,
                    // next line is important!
                    appBarTheme: AppBarTheme(brightness: Brightness.dark)),
                // Start the app on the landing page. This could be made conditional
                // depending on the state of the login.
                // initialRoute: RouteName.HOME,
                home: FutureBuilder(
                    future: getUserData(),
                    builder: (context, AsyncSnapshot<User> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        default:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          else if ((snapshot.data?.token ?? 'null') == 'null') {
                            UserPreference().removeUser();
                            return Landing();
                          } else {
                            var auth = Provider.of<AuthProvider>(context,
                                listen: false);
                            var user = Provider.of<UserProvider>(context,
                                listen: false);

                            auth.loggedInStatus = Status.LoggedIn;
                            auth.registeredStatus = Status.Registered;
                            user.initializeUser(snapshot.data!);
                            auth.verificationStatus = user.user.verified
                                ? Status.Verified
                                : Status.NotVerified;
                          }
                          return Home();
                      }
                    }),

                // home: loginFuture,
                // Routes are used for app and web navigation. For example,
                // hitting the back button returns to the previous route.
                routes: {
              RouteName.LANDING: (context) => Landing(),
              RouteName.SIGNUP: (context) => Signup(),
              RouteName.LOGIN: (context) => Login(),
              RouteName.FORGOTPASSWORD: (context) => ForgotPassword(),
              RouteName.HOME: (context) => Home(),
              RouteName.VERIFICATION: (context) => Verification()
            }));
  }
}
