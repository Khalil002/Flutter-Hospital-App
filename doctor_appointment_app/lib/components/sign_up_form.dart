import 'package:doctor_appointment_app/components/button.dart';
import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';
import '../utils/config.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String _sexController = 'male';
  var items = [
    'male',
    'female',
  ];
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _dateController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime.now(),
                  onChanged: (date) {}, onConfirm: (date) {
                _dateController.text = DateFormat('yyyy-MM-dd').format(date);
                log(date.toString());
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            decoration: const InputDecoration(
              hintText: 'Birthdate',
              labelText: 'Birthdate',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.date_range),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          DropdownButtonFormField(
            // Initial Value
            value: _sexController,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),
            // Down Arrow Icon

            decoration: InputDecoration(
              hintText: 'Select Sex', // You can customize this hint text
              labelText: 'Sex', // You can customize this label text
              prefixIcon: Icon(_sexController == 'male'
                  ? Icons.male_rounded
                  : Icons.female_rounded),
              prefixIconColor: Config.primaryColor,
              alignLabelWithHint: true,
            ),
            // Array list of items
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                _sexController = newValue!;
              });
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  final userRegistration = await DioProvider().registerUser(
                      _nameController.text,
                      _dateController.text,
                      _sexController,
                      _emailController.text,
                      _passController.text);
                  log("User registered to database");
                  //if register success, proceed to login
                  if (userRegistration) {
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);
                    if (token) {
                      //auth.loginSuccess(json.decode(token), {}); //update login status
                      //get user data
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final tokenValue = prefs.getString('token') ?? '';

                      if (tokenValue.isNotEmpty && tokenValue != '') {
                        final response =
                            await DioProvider().getUser(tokenValue);
                        if (response != null) {
                          setState(() {
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
                          });
                        }
                      }
                      log("auth success");
                      //rediret to main page
                      MyApp.navigatorKey.currentState!.pushNamed('main');
                    }
                  } else {
                    log("logging unsucessful");
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}

//now, let's get all doctor details and display on Mobile screen
