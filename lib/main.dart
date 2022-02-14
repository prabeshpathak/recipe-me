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
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  // ignore: invalid_use_of_visible_for_testing_member
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'recipeme',
            channelName: 'Recipe Me',
            channelDescription: "Notification For The App",
            defaultColor: const Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            importance: NotificationImportance.High,
            enableVibration: true)
      ]);

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

void getnn() async{
  final pref  = await SharedPreferences.getInstance();
  final String? user = pref.getString('userId');
  print(user);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreference().getUser();
    MaterialColor colorCustom = MaterialColor(0xFF131516, color);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IngredientModel()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child: MaterialApp(
            title: 'Recipe-Me',
            theme: ThemeData(
                fontFamily: GoogleFonts.poppins().fontFamily,
                primaryColor: Colors.black,
                primaryColorBrightness: Brightness.dark,
                primaryColorLight: Colors.black,
                brightness: Brightness.dark,
                primaryColorDark: Colors.black,
                indicatorColor: Colors.white,
                canvasColor: Colors.black,
                appBarTheme: AppBarTheme(brightness: Brightness.dark)),
            // initialRoute: RouteName.HOME,
            home: FutureBuilder(
                future: getUserData(),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if ((snapshot.data?.token ?? 'null') == 'null') {
                        print('here');
                        getnn();
                        UserPreference().removeUser();
                        return Landing();
                      } else {
                        var auth =
                            Provider.of<AuthProvider>(context, listen: false);
                        var user =
                            Provider.of<UserProvider>(context, listen: false);

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
