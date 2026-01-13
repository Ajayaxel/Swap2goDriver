import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swap2godriver/repo/location_repo.dart';
import 'package:swap2godriver/screens/profile/profile_screen.dart';
import 'package:swap2godriver/screens/wallet/wallet_screen.dart';
import 'package:swap2godriver/themes/app_colors.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationRepository _locationRepo = LocationRepository();
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.2048, 55.2708), // Dubai coordinates
    zoom: 14.4746,
  );

  LatLng _selectedLocation = _kGooglePlex.target;
  Set<Marker> _markers = {};
  bool _isFullScreen = false;
  bool _isLoading = false;
  MapType _currentMapType = MapType.normal;

  LatLng? _initialLocation;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLocate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionsAndLocate() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Fallback if permission denied
      setState(() {
        _initialLocation = _kGooglePlex.target;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });

      _updateLocationAndMarker(position.latitude, position.longitude);

      // Auto-update on initial load
      _updateLocationApi(
        position.latitude,
        position.longitude,
        showToast: false,
      );
    } catch (e) {
      print("Error getting location: $e");
      // Fallback on error
      setState(() {
        _initialLocation = _kGooglePlex.target;
      });
    }
  }

  void _updateLocationAndMarker(double lat, double lng) {
    setState(() {
      _selectedLocation = LatLng(lat, lng);
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: 'Selected Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
    _getAddressFromLatLng(lat, lng);
  }

  void _onMapTap(LatLng position) {
    _updateLocationAndMarker(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.locality}, ${place.country}";
        setState(() {
          _searchController.text = address;
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  Future<void> _updateLocationApi(
    double lat,
    double lng, {
    bool showToast = true,
  }) async {
    setState(() {
      _isLoading = showToast; // Only show loading if we are manually updating
    });

    bool success = await _locationRepo.updateLocation(lat, lng);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success && showToast) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (!success && showToast) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update location'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialLocation!,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: _onMapTap,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),

                // Top Bar (Search & Icons)
                if (!_isFullScreen)
                  Positioned(
                    top: 50,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WalletScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.wallet,
                                  color: AppColors.backgroundColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPMKB26bDZJ66lM1xKDKASA_nf9uDA9uTy5A&s',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: GooglePlaceAutoCompleteTextField(
                                  textEditingController: _searchController,
                                  googleAPIKey:
                                      "AIzaSyCyWXFiBQAQ6qBpb3Mq_YKta4Y_dI5c4X0",
                                  inputDecoration: const InputDecoration(
                                    hintText: "Search location",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  debounceTime: 800,
                                  countries: const [
                                    "ae",
                                  ], // Optional: restrict to UAE
                                  isLatLngRequired: true,
                                  getPlaceDetailWithLatLng:
                                      (Prediction prediction) {
                                        if (prediction.lat != null &&
                                            prediction.lng != null) {
                                          double lat = double.parse(
                                            prediction.lat!,
                                          );
                                          double lng = double.parse(
                                            prediction.lng!,
                                          );

                                          _updateLocationAndMarker(lat, lng);

                                          _controller.future.then((controller) {
                                            controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: LatLng(lat, lng),
                                                  zoom: 15,
                                                ),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                  itemClick: (Prediction prediction) {
                                    _searchController.text =
                                        prediction.description ?? "";
                                    _searchController
                                        .selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _searchController.text.length,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Full Screen Toggle, Map Type & Current Location
                Positioned(
                  bottom: 100,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "mapType",
                        onPressed: _toggleMapType,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.layers, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: "fullscreen",
                        onPressed: _toggleFullScreen,
                        backgroundColor: Colors.white,
                        child: Icon(
                          _isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        heroTag: "location",
                        onPressed: _getCurrentLocation,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Confirm Location Button
                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _updateLocationApi(
                              _selectedLocation.latitude,
                              _selectedLocation.longitude,
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Confirm Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
