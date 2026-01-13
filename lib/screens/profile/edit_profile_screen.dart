import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap2godriver/bloc/profile/profile_bloc.dart';
import 'package:swap2godriver/models/profile_model.dart';
import 'package:swap2godriver/themes/app_colors.dart';
import 'package:swap2godriver/widget/btn.dart';

class EditProfileScreen extends StatefulWidget {
  final DriverProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _vehicleNumberController = TextEditingController(
      text: widget.profile.vehicleNumber,
    );
    _vehicleTypeController = TextEditingController(
      text: widget.profile.vehicleType,
    );
    _vehicleModelController = TextEditingController(
      text: widget.profile.vehicleModel,
    );
    _vehicleColorController = TextEditingController(
      text: widget.profile.vehicleColor,
    );
    _addressController = TextEditingController(text: widget.profile.address);
    _cityController = TextEditingController(text: widget.profile.city);
    _stateController = TextEditingController(text: widget.profile.state);
    _postalCodeController = TextEditingController(
      text: widget.profile.postalCode,
    );
    _countryController = TextEditingController(text: widget.profile.country);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleNumberController.dispose();
    _vehicleTypeController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        "name": _nameController.text,
        "phone": _phoneController.text,
        "vehicle_number": _vehicleNumberController.text,
        "vehicle_type": _vehicleTypeController.text,
        "vehicle_model": _vehicleModelController.text,
        "vehicle_color": _vehicleColorController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "postal_code": _postalCodeController.text,
        "country": _countryController.text,
      };

      context.read<ProfileBloc>().add(UpdateProfile(updatedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _buildTextField('Name', _nameController),
                const SizedBox(height: 16),
                _buildTextField(
                  'Phone',
                  _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Vehicle Information'),
                const SizedBox(height: 16),
                _buildTextField('Vehicle Number', _vehicleNumberController),
                const SizedBox(height: 16),
                _buildTextField('Vehicle Type', _vehicleTypeController),
                const SizedBox(height: 16),
                _buildTextField('Vehicle Model', _vehicleModelController),
                const SizedBox(height: 16),
                _buildTextField('Vehicle Color', _vehicleColorController),
                const SizedBox(height: 24),
                _buildSectionTitle('Address Information'),
                const SizedBox(height: 16),
                _buildTextField('Address', _addressController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('City', _cityController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('State', _stateController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Postal Code',
                        _postalCodeController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField('Country', _countryController),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Btn(onPressed: _submitForm, text: 'Update Profile'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
