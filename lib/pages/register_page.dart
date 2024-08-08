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


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AlertService _alertService;
  late DatabaseService _databaseService;
  late StorgeService _storageService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late MediaService _mediaService;
  
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final GetIt _getIt = GetIt.instance;

  bool isLoading = false;
  File? selectedImage;
  String? name, email, password, role;

  final List<String> roles = ['Admin', 'User'];

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorgeService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              if (!isLoading) _registerForm(),
              if (!isLoading) _loginAccount(),
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _profilePictureSelectionField(),
            CustomFormField(
              hintText: 'Email',
              regExpressionValidation: EMAIL_VALIDATION_REGEX,
              onSaved: (value) => email = value,
            ),
            CustomFormField(
              hintText: 'User name',
              regExpressionValidation: NAME_VALIDATION_REGEX,
              onSaved: (value) => name = value,
            ),
            CustomFormField(
              hintText: 'Password',
              regExpressionValidation: PASSWORD_VALIDATION_REGEX,
              onSaved: (value) => password = value,
            ),
            _roleDropdown(),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _roleDropdown() {
    return DropdownButtonFormField<String>(
      value: role,
      hint: const Text('Select Role'),
      items: roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          role = newValue!;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a role';
        }
        return null;
      },
    );
  }

  Widget _profilePictureSelectionField() {
    return InkWell(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.14,
        backgroundColor: Colors.grey,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            :  NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () async {
          if (_registerFormKey.currentState?.validate() ?? false && selectedImage != null) {
            setState(() {
              isLoading = true;
            });
            _registerFormKey.currentState?.save();
            try {
              bool result = await _authService.register(email!, password!);
              if (result) {
                String? pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid);
                if (pfpURL != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                      uid: _authService.user!.uid,
                      name: name!,
                      pfpURL: pfpURL,
                      role: role!,
                    ),
                  );
                  _navigationService.goBack();
                  _navigateToRoleBasedScreen(role!);
                  _alertService.showToast(text: 'User registered successfully', icon: Icons.check);
                } else {
                  throw Exception('Unable to upload user profile picture');
                }
              } else {
                throw Exception('Unable to register');
              }
            } catch (e) {
              _alertService.showToast(text: '$e', icon: Icons.error);
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        child: const Text('Register'),
      ),
    );
  }

  Widget _loginAccount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already Have An Account"),
          InkWell(
            onTap: () {
           _navigationService.pushReplacementNamed('/login');
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }


    void _navigateToRoleBasedScreen(String role) {
    if (role == 'Admin') {
      _navigationService.pushReplacementNamed('/adminHome');
    } else {
      _navigationService.pushReplacementNamed('/userHome');
    }
  }
}
