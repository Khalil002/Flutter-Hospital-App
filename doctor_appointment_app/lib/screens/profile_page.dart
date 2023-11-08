import "dart:math";

import "package:doctor_appointment_app/main.dart";
import "package:doctor_appointment_app/utils/config.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/auth_model.dart";
import "../providers/dio_provider.dart";
import "package:provider/provider.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileDetails(Map<String, dynamic> user) {
    DateTime dob = DateTime.parse(user['dateOfBirth']);
    DateTime today = DateTime.now();

    final year = today.year - dob.year;
    final mth = today.month - dob.month;
    final days = today.day - dob.day;

    int age = year;
    if (mth < 0) {
      age = age - 1;
    } else if (mth == 0 && days < 0) {
      age = age - 1;
    }
    String gender = user['sex'] == "male" ? "Male" : "Female";
    String s = "$age Years old | $gender";
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Config.primaryColor,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 110,
                ),
                const CircleAvatar(
                  radius: 65.0,
                  backgroundImage: AssetImage('assets/profile2.jpg'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AuthModel>(
                  builder: (context, auth, child) {
                    return Text(
                      auth.getUser['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    );
                  },
                  //child:
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AuthModel>(
                  builder: (context, auth, child) {
                    return Text(
                      profileDetails(auth.getUser),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    );
                  },
                  //child:
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Center(
                //margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
              children: [
                Divider(
                  color: Colors.grey[300],
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        color: Colors.lightGreen[400],
                        size: 35,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {},
                        // onPressed: () async {
                        //   final SharedPreferences prefs =
                        //       await SharedPreferences.getInstance();
                        //   final token = prefs.getString('token') ?? '';

                        //   if (token.isNotEmpty && token != '') {
                        //     //logout here
                        //     final response = await DioProvider().logout(token);

                        //     if (response == 200) {
                        //       //if successfully delete access token
                        //       //then delete token saved at Shared Preference as well
                        //       await prefs.remove('token');
                        //       setState(() {
                        //         //redirect to login page
                        //         MyApp.navigatorKey.currentState!
                        //             .pushReplacementNamed('/');
                        //       });
                        //     }
                        //   }
                        // },
                        child: const Text(
                          "Change profile picture",
                          style: TextStyle(
                            color: Config.primaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.lightGreen[400],
                        size: 35,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final token = prefs.getString('token') ?? '';

                          if (token.isNotEmpty && token != '') {
                            //logout here
                            final response = await DioProvider().logout(token);

                            if (response == 200) {
                              //if successfully delete access token
                              //then delete token saved at Shared Preference as well
                              await prefs.remove('token');
                              setState(() {
                                //redirect to login page
                                MyApp.navigatorKey.currentState!
                                    .pushReplacementNamed('/');
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Config.primaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
