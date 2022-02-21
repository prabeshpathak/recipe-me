import 'dart:async';

import 'package:recipe_app_flutter/utils/BaseAPI.dart';
import 'package:recipe_app_flutter/utils/AuthProvider.dart';
import 'package:recipe_app_flutter/utils/exportRoutes.dart';
import 'package:recipe_app_flutter/utils/UserProvider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

sendNotification() {
  AwesomeNotifications().isNotificationAllowed().then(((value) => {
        if (!value)
          {AwesomeNotifications().requestPermissionToSendNotifications()}
      }));

  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 4,
    channelKey: 'recipeme',
    title: 'Successfully Logged Out',
    body: 'Hope to See you soon.',
  ));
}

class AccountInfo extends StatefulWidget {
  @override
  AccountInfoState createState() => AccountInfoState();
}

class AccountInfoState extends State<AccountInfo> {
  List<double>? _accelerometerValues;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
            print(event.x);
          if (event.x > 35) {
            // logout user
            AuthProvider auth =
                Provider.of<AuthProvider>(context, listen: false);
            auth.logout();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Logged out')));
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.LANDING, (_) => false);
          }
        },
      ),
    );
  }

  Widget _buildLogoutButton(context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return ElevatedButton(
      onPressed: () {
        auth.logout();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged out')));
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.LANDING, (_) => false);
        sendNotification();
      },
      child: Text('Logout'),
    );
  }

  Widget _buildCenteredIndicator() {
    return Center(
        child: SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(),
    ));
  }

  Widget _accountInfo(String token) {
    return FutureBuilder(
      future: API().getUserInfo(token),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.all(10), child: _buildCenteredIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 32));
            else {
              var data = Map.from(snapshot.data!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      data['avatar'] != null
                          ? CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(data['avatar']),
                            )
                          : CircleAvatar(
                              radius: 22,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Text(data['display']
                                  .toString()
                                  .toUpperCase()
                                  .substring(0, 2)),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '${data['display']} ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 190, 186, 186),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 38)),
                            WidgetSpan(
                              child: data['verified'] == true
                                  ? Icon(
                                      Icons.verified,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 38,
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(data['email'],
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 190, 186, 186))),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLogoutButton(context),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 190, 186, 186),
                                size: 18,
                              )),
                              TextSpan(
                                  text:
                                      ' Joined ${formatDate(DateTime.parse(data['dateSignedUp']), [
                                        MM,
                                        ' ',
                                        yyyy
                                      ])}',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 190, 186, 186),
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                      ]),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: data['favorites'].length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: data['favorites'].length == 1
                                    ? ' Liked Recipe'
                                    : ' Liked Recipes',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 186, 186))),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: data['recipeList'].length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: data['recipeList'].length == 1
                                    ? ' Created Recipe'
                                    : ' Created Recipes',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 190, 186, 186))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    return Container(
      constraints: BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(15.0),
      child: _accountInfo(user.token),
    );
  }
}
