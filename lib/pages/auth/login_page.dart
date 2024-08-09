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
  bool _isLoading = false;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _formFields(),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                _loginButton(),
              SizedBox(height: 20),
              _createAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formFields() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormField(
            hintText: 'Email',
            regExpressionValidation: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              email = value;
            },
          ),
          SizedBox(height: 10),
          CustomFormField(
            hintText: 'Password',
            regExpressionValidation: PASSWORD_VALIDATION_REGEX,
            onSaved: (value) {
              password = value;
            },
           
          ),
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
            _loginFormKey.currentState?.save();
            setState(() {
              _isLoading = true;
            });

            try {
              bool result = await _authService.login(email!, password!);
              if (result) {
                final user = _authService.user;
                if (user != null) {
                  final userProfile =
                      await _databaseService.getUserProfileByUid(user.uid);
                  if (userProfile != null) {
                    if (userProfile.role == 'Admin') {
                      _navigationService.pushReplacementNamed('/adminHome');
                    } else if (userProfile.role == 'User') {
                      _navigationService.pushReplacementNamed('/userHome');
                    }
                    _alertService.showToast(
                      text: 'Successfully logged in',
                      icon: Icons.check,
                    );
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
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        child: Text('Login'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _createAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? "),
        GestureDetector(
          onTap: () {
            _navigationService.pushNamed("/registration");
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
