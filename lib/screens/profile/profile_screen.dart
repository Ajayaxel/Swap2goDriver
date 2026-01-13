import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap2godriver/bloc/profile/profile_bloc.dart';
import 'package:swap2godriver/models/profile_model.dart';
import 'package:swap2godriver/repo/profile_repo.dart';
import 'package:swap2godriver/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(ProfileRepository())..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      final bloc = context.read<ProfileBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: EditProfileScreen(profile: state.profile),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProfileLoaded) {
              return _buildProfileContent(context, state.profile);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, DriverProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPMKB26bDZJ66lM1xKDKASA_nf9uDA9uTy5A&s',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            profile.email,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildInfoSection('Personal Information', [
            _buildInfoRow('Phone', profile.phone),
            _buildInfoRow('Address', '${profile.address}, ${profile.city}'),
            _buildInfoRow('State', profile.state),
            _buildInfoRow('Country', profile.country),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Vehicle Information', [
            _buildInfoRow(
              'Vehicle',
              '${profile.vehicleColor} ${profile.vehicleModel}',
            ),
            _buildInfoRow('Number', profile.vehicleNumber),
            _buildInfoRow('Type', profile.vehicleType),
          ]),
          const SizedBox(height: 24),
          _buildInfoSection('Status', [
            _buildInfoRow('Status', profile.status),
            _buildInfoRow('Availability', profile.availabilityStatus),
            _buildInfoRow('Verified', profile.isVerified ? 'Yes' : 'No'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Online Status',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Switch(
                  value: profile.isOnline,
                  onChanged: (value) {
                    context.read<ProfileBloc>().add(UpdateAvailability(value));
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
