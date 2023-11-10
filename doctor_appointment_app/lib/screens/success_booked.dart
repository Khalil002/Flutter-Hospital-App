import 'package:doctor_appointment_app/components/button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer';
import "package:provider/provider.dart";
import "../models/auth_model.dart";
import 'dart:convert';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Lottie.asset('assets/success.json'),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Successfully Booked',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                //back to home page
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Button(
                    width: double.infinity,
                    title: 'Back to Home Page',
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final token = prefs.getString('token') ?? '';

                      //if successful, then refresh
                      final response = await DioProvider().getUser(token);

                      if (response != null) {
                        //setState(() {
                        //json decode
                        Map<String, dynamic> appointment = {};
                        final user = json.decode(response);

                        //check if any appointment today
                        for (var doctorData in user['doctor']) {
                          //if there is appointment return for today

                          if (doctorData['appointments'] != null) {
                            appointment = doctorData;
                          }
                        }

                        auth.loginSuccess(user, appointment);

                        MyApp.navigatorKey.currentState!.pushNamed('main');
                        //});
                      }
                      //get user data

                      //MyApp.navigatorKey.currentState!
                      // .pushNamed('main');
                    },
                    disable: false,
                  ),
                )
              ],
            ),
          ),
        );
      },

      //child:
    );
  }
}
