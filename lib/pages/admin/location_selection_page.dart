import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/firestore_service.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final GetIt _getIt = GetIt.instance;
  late AlertService _alertService;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'country': TextEditingController(),
    'state': TextEditingController(),
    'district': TextEditingController(),
    'city': TextEditingController(),
  };
  bool _isLoading = false; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add a New Location',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildTextField('Country', 'country'),
                        _buildTextField('State', 'state'),
                        _buildTextField('District', 'district'),
                        _buildTextField('City', 'city'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Add Location'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) // Show loader if loading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true; // Show loader
      });
      try {
        await FirestoreService().addLocation(
          _controllers['country']!.text,
          _controllers['state']!.text,
          _controllers['district']!.text,
          _controllers['city']!.text,
        );
        _alertService.showToast(
          text: 'Location added successfully!',
          icon: Icons.check,
        );
        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        _alertService.showToast(
          text: "Can't add location, try again",
          icon: Icons.error,
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
    } else {
      _alertService.showToast(
        text: "Please fill in all fields correctly",
        icon: Icons.error,
      );
    }
  }
}
