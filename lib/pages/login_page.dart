
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
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
    super.initState();
  }

  final GlobalKey<FormState> _Loginformkey = GlobalKey();

  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;
  late AlertService _alertService;

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidUI(),
    );
  }

  Widget _buidUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _formfiled(),
            _createanacount(),
          ],
        ),
      ),
    );
  }

  Widget _formfiled() {
    return Form(
      key: _Loginformkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustiomFormfiled(
            hintText: 'Email',
            regExpressionvalidation: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          CustiomFormfiled(
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
            hintText: 'Password',
            regExpressionvalidation: PASSWORD_VALIDATION_REGEX,
          ),
          _loginbutton(),
        ],
      ),
    );
  }

  Widget _loginbutton() {
    return SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            if (_Loginformkey.currentState?.validate() ?? false) {
              _Loginformkey.currentState?.save();
              bool result = await _authService.login(email!, password!);

              if (result) {
                _navigationService.pushReplacementNamed('/home');
                _alertService.showToasr(
                    text: 'success fully login', icon: Icons.check);
              } else {
                _alertService.showToasr(text: 'try again', icon: Icons.error);
              }
            }
          },
          child: Text('login'),
        ));
  }

  Widget _createanacount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account ?"),
          InkWell(
            onTap: () {
              _navigationService.pushNamed("/registration");
            },
            child: const Text(
              'signup',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
