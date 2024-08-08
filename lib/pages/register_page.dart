import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/model/users_profile.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/media_service%20.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/service/storge_service.dart';
import 'package:newtoktask/widget/const.dart';
import 'package:newtoktask/widget/custiom_formfiled.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  @override
  void initState() {
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storgeService = _getIt.get<StorgeService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
    super.initState();
  }

  bool isloading = false;
  late AlertService _alertService;
  late DatabaseService _databaseService;
  late StorgeService _storgeService;
  final GlobalKey<FormState> _registerformkey = GlobalKey();
  late NavigationService _navigationService;
  late AuthService _authService;
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  File? selectedimage;
  String? name, email, password;
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
          children: [
            if (!isloading) _rgisterform(),
            if (!isloading) _loginAcount(),
            if (isloading)
              Expanded(
                  child: Center(
                      child: CircularProgressIndicator(
                color: Colors.black,
              )))
          ],
        ),
      ),
    );
  }

  Widget _rgisterform() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        // key: _Loginformkey,
        child: Form(
          key: _registerformkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              pfpselectionfield(),
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
                hintText: 'User name',
                regExpressionvalidation: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              CustiomFormfiled(
                hintText: 'Password',
                regExpressionvalidation: PASSWORD_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              _registerbutton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget pfpselectionfield() {
    return InkWell(
      onTap: () async {
        File? file = await _mediaService.getimagefromGallery();
        if (file != null) {
          setState(() {
            selectedimage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.14,
        backgroundColor: Colors.grey,
        backgroundImage: selectedimage != null
            ? FileImage(selectedimage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerbutton() {
    return SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            try {
              print('-----------------1--------------');
              if ((_registerformkey.currentState?.validate() ?? false) &&
                  selectedimage != null) {
                setState(() {
                  isloading = true;
                });
                _registerformkey.currentState?.save();
                bool result = await _authService.register(email!, password!);
                print('-----------------2--------------');
                if (result) {
                  print('-----------------3--------------');
                  String? pfpURL = await _storgeService.uploadUserPfp(
                      file: selectedimage!, uid: _authService.user!.uid);
                  print('-----------4--------------------');
                  if (pfpURL != null) {
                    print('-----------------5--------------');
                    await _databaseService.createUserProfile(
                        userprofile: UserProfile(
                            uid: _authService.user!.uid,
                            name: name,
                            pfpURL: pfpURL));

                    print('-------------6------------------');
                    setState(() {
                      isloading = false;
                    });
                    _navigationService.goBack();
                    _navigationService.pushReplacementNamed('/home');
                    _alertService.showToasr(
                        text: 'User registerd successfuly', icon: Icons.check);
                  } else {
                    throw Exception('Unable to user profile');
                  }
                } else {
                  throw Exception('Unable to register');
                }
              } else {
                throw Exception('Unable to register');
              }
            } catch (e) {
              setState(() {
                isloading = false;
              });
              _alertService.showToasr(text: '$e', icon: Icons.error);
              print(e);
            }
          },
          child: const Text('Register'),
        ));
  }

  Widget _loginAcount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already Have An Account"),
          InkWell(
            onTap: () {
              _navigationService.pushNamed("/login");
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
