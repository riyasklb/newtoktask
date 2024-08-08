import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/widget/const.dart';
import 'package:newtoktask/widget/custiom_formfiled.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
    super.initState();
  }

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _formFields(),
            _createAccount(),
          ],
        ),
      ),
    );
  }

  Widget _formFields() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomFormField(
            hintText: 'Email',
            regExpressionValidation: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          CustomFormField(
            hintText: 'Password',
            regExpressionValidation: PASSWORD_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            print('-----------------------1--------------------------');
            _loginFormKey.currentState?.save();
              print('-----------------------2--------------------------');
            try {
               print('-----------------------3--------------------------');
              bool result = await _authService.login(email!, password!);
               print('-----------------------4--------------------------');
              if (result) {
               print('-----------------------5--------------------------');

                final user = _authService.user;
                 print('-----------------------6--------------------------');
                if (user != null) {
                   print('-----------------------7--------------------------');
                  final userProfile =
                      await _databaseService.getUserProfileByUid(user.uid);
                          print('-----------------------8--------------------------');
                  if (userProfile != null) {
                    print('-----------------------9--------------------------');
                    if (userProfile.role == 'Admin') {
                      
                    print('-----------------------10--------------------------');
                      print(
                          '--------------- ${userProfile.role}------------------------');
                      _navigationService.pushReplacementNamed('/adminHome');
                      _alertService.showToast(
                        text: 'Successfully logged in',
                        icon: Icons.check,
                      );
                    } else if (userProfile.role == 'User') {
                      print(
                          '--------------- ${userProfile.role}------------------------');
                      _navigationService.pushReplacementNamed('/userHome');
                      _alertService.showToast(
                        text: 'Successfully logged in',
                        icon: Icons.check,
                      );
                    }
                  } else {
                    _alertService.showToast(
                      text: 'User profile not found',
                      icon: Icons.error,
                    );
                  }
                } else {
                  _alertService.showToast(
                    text: 'Failed to get user',
                    icon: Icons.error,
                  );
                }
              } else {
                _alertService.showToast(
                  text: 'Invalid email or password',
                  icon: Icons.error,
                );
              }
            } catch (e) {
              _alertService.showToast(
                text: 'An error occurred: $e',
                icon: Icons.error,
              );
            }
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Widget _createAccount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          InkWell(
            onTap: () {
              _navigationService.pushNamed("/registration");
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
