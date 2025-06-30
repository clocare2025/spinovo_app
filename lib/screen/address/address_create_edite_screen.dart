import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/providers/address_provider.dart';
import 'package:spinovo_app/providers/location_provider.dart';
import 'package:spinovo_app/screen/auth/details_screen.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';
import 'package:spinovo_app/utiles/toast.dart';
import 'package:spinovo_app/widget/roundedChoiceChip.dart';
import 'package:spinovo_app/widget/button.dart';
import 'package:spinovo_app/widget/custom_textfield.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';
import 'package:spinovo_app/models/address_model.dart';

class AddressCreateEditScreen extends StatefulWidget {
  final String? addressId;
  const AddressCreateEditScreen({super.key, this.addressId});

  @override
  // ignore: library_private_types_in_public_api
  _AddressCreateEditScreenState createState() =>
      _AddressCreateEditScreenState();
}

class _AddressCreateEditScreenState extends State<AddressCreateEditScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(23.0319, 72.5440);
  String _currentAddress = "Fetching address...";
  bool _isLoadingLocation = false;
  bool _isServiceAvailable = false;
  bool _isMapReady = false;
  Placemark? _currentPlacemark;
  AddressData? _existingAddress;

  // final List<String> _serviceablePincodes = [
  //   "380009",
  //   "380013",
  //   "380014",
  //   "390035",
  //   "380058",
  // ];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String _saveAs = "Home";
  String _petsAtHome = "NO";
  final List<String> addressTypeList = [
    'Home',
    'Work',
    'Hostel/PG',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
        Provider.of<LocationProvider>(context, listen: false).getLocationList();
    if (widget.addressId != null) {
      _loadExistingAddress();
    } else {
      _checkAndRequestPermissions();
    }
  }

  void _loadExistingAddress() {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final address = addressProvider.addresses.firstWhere((addr) => addr.addressId == widget.addressId);
    setState(() {
      _existingAddress = address;
      _saveAs = address.addressType ?? _saveAs;
      _petsAtHome = address.petsAtHome ?? _petsAtHome;
      _houseNumberController.text = address.flatNo ?? '';
      _flatController.text = address.building ?? '';
      _currentAddress = address.formatAddress ?? "Fetching address...";
      double latitude = double.parse(address.latitude ?? '23.0319');
      double longitude = double.parse(address.longitude ?? '72.5440');
      _initialPosition = LatLng(latitude, longitude);
      // _isServiceAvailable = address.pincode != null &&
      //     _serviceablePincodes.contains(address.pincode);
          

          _isServiceAvailable = address.pincode != null &&
    (locationProvider.locationModel?.data?.pincode
            ?.contains(address.pincode) ??
        false);
    });
    if (_isMapReady) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 15),
      );
    }
  }

  Future<void> _addressSave(
      AddressProvider addressProvider,
      TextEditingController houseNumberController,
      TextEditingController flatController) async {
    final String flatNo = houseNumberController.text.trim();
    final String building = flatController.text.trim();
    if (_currentPlacemark == null && widget.addressId == null) {
      showToast('Please select a valid address');
      return;
    }
    if (flatNo.isEmpty) {
      showToast('Please enter house number');
      return;
    }
    if (building.isEmpty) {
      showToast('Please enter apartment/building/block');
      return;
    }

    final addressData = {
      'address_type': _saveAs,
      'flat_no': flatNo,
      'building': building,
      'street': _currentPlacemark?.street ?? _existingAddress?.street ?? '',
      'landmark':
          _currentPlacemark?.subLocality ?? _existingAddress?.landmark ?? '',
      'city': _currentPlacemark?.locality ?? _existingAddress?.city ?? '',
      'state': _currentPlacemark?.administrativeArea ??
          _existingAddress?.state ??
          '',
      'pincode':
          _currentPlacemark?.postalCode ?? _existingAddress?.pincode ?? '',
      'petsAtHome': _petsAtHome,
      'latitude': _initialPosition.latitude.toString(),
      'longitude': _initialPosition.longitude.toString(),
    };

    try {
      if (widget.addressId != null) {
        await addressProvider.updateAddress(addressData, widget.addressId!);
        showToast('Address updated successfully');
      } else {
        await addressProvider.createAddress(addressData);
        showToast('Address saved successfully');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
    } catch (e) {
      showToast('Failed to save address: $e');
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool? enableService = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Services Disabled"),
          content: const Text(
              "Please enable location services to use this feature."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Enable"),
            ),
          ],
        ),
      );

      if (enableService == true) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          showToast('Location services are required to proceed');
          return;
        }
      } else {
        showToast('Location services are required to proceed');
        return;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        bool? retry = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Permission Denied"),
            content: const Text(
                "This app needs location access to function properly. Please grant the permission."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Retry"),
              ),
            ],
          ),
        );

        if (retry == true) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            showToast('Location permissions are denied');
            return;
          }
        } else {
          showToast('Location permissions are denied');
          return;
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      bool? openSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Permission Denied"),
          content: const Text(
              "Location permissions are permanently denied. Please enable them in the app settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        await Geolocator.openAppSettings();
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          showToast('Location permissions are permanently denied');
          return;
        }
      } else {
        showToast('Location permissions are permanently denied');
        return;
      }
    }

    if (_isMapReady) {
      await _getCurrentLocation();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _getCurrentLocation();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception("Timed out while fetching location");
      });

      LatLng newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        _initialPosition = newPosition;
      });

      if (_mapController != null && _isMapReady) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 15),
        );
      }
      await _updateAddress(newPosition);
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _initialPosition = const LatLng(23.0365, 72.5611);
      });
      if (_mapController != null && _isMapReady) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_initialPosition, 15),
        );
      }
      await _updateAddress(_initialPosition);
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      setState(() {
        _currentPlacemark = place;
        _currentAddress =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        // _isServiceAvailable = place.postalCode != null && _serviceablePincodes.contains(place.postalCode);

        _isServiceAvailable = place.postalCode != null && (locationProvider.locationModel?.data?.pincode ?.contains(place.postalCode) ?? false);
      });
      if (locationProvider.errorMessage != null) {
  showToast(locationProvider.errorMessage!);
}
    } catch (e) {
      setState(() {
        _currentAddress = "Unable to fetch address";
        _isServiceAvailable = false;
      });
      showToast('Error fetching address: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _isMapReady = true;
    });
    if (_isMapReady) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 15),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _initialPosition = position.target;
    });
    _updateAddress(position.target);
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      List<Map<String, dynamic>> results = [];

      for (var location in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        if (placemarks.isEmpty) continue;

        Placemark place = placemarks[0];
        String address =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.thoroughfare ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}, ${place.postalCode ?? ''}";

        results.add({
          'address': address,
          'latLng': LatLng(location.latitude, location.longitude),
        });
      }

      setState(() {
        _searchResults.addAll(results);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showSearchBottomSheet() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Height(20),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for your location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setModalState(() {
                              _searchResults = [];
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _searchLocations(value);
                        setModalState(() {});
                      },
                    ),
                    const Height(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.my_location),
                          label: const Text("Current Location"),
                          onPressed: () {
                            Navigator.pop(context);
                            _getCurrentLocation();
                          },
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text("Locate on Map"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          var result = _searchResults[index];
                          return ListTile(
                            leading: const Icon(Icons.location_pin,
                                color: Colors.grey),
                            title: Text(result['address']),
                            onTap: () async {
                              setState(() {
                                _initialPosition = result['latLng'];
                              });
                              if (_mapController != null && _isMapReady) {
                                await _mapController!.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      _initialPosition, 15),
                                );
                              }
                              await _updateAddress(_initialPosition);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                    const Height(20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSaveAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _currentAddress.split(',')[0],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSearchBottomSheet();
                            },
                            child: SmallText(
                              text: "Change",
                              size: 16,
                              color: const Color.fromARGB(227, 76, 175, 79),
                              fontweights: FontWeight.w500,
                            )),
                      ],
                    ),
                    const Height(5),
                    SmallText(
                      text: _currentAddress,
                    ),
                    const Height(10),
                    customTextField(
                      height: 45,
                      controller: _houseNumberController,
                      hintText: 'House / Flat / Floor Number',
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                    ),
                    const Height(10),
                    customTextField(
                      height: 45,
                      controller: _flatController,
                      hintText: 'Appartment / Building / Block',
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                    ),
                    const Height(10),
                    const TextTitle(title: 'Save as', optionalText: '*'),
                    const Height(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: addressTypeList.map((type) {
                        final isSelected = _saveAs == type;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: HouseholdTypeBox(
                              text: type,
                              isSelected: isSelected,
                              onTap: () {
                                setModalState(() {
                                  _saveAs = type;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Height(10),
                    const TextTitle(title: 'Do you have pets at home?'),
                    const Height(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedChoiceChip(
                          label: const Text("NO"),
                          selected: _petsAtHome == "NO",
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                _petsAtHome = "NO";
                              });
                            }
                          },
                          labelStyle: TextStyle(
                            color: _petsAtHome == "NO"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const Widths(15),
                        RoundedChoiceChip(
                          label: Image.asset(
                            "asset/icons/cat.png",
                            height: 20,
                            color: _petsAtHome == "Cat"
                                ? Colors.white
                                : Colors.black,
                          ),
                          selected: _petsAtHome == "Cat",
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                _petsAtHome = "Cat";
                              });
                            }
                          },
                          labelStyle: TextStyle(
                            color: _petsAtHome == "Cat"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const Widths(15),
                        RoundedChoiceChip(
                          label: Image.asset(
                            "asset/icons/dog.png",
                            height: 20,
                            color: _petsAtHome == "Dog"
                                ? Colors.white
                                : Colors.black,
                          ),
                          selected: _petsAtHome == "Dog",
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                _petsAtHome = "Dog";
                              });
                            }
                          },
                          labelStyle: TextStyle(
                            color: _petsAtHome == "Dog"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Height(20),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer<AddressProvider>(
                        builder: (context, addressProvider, child) {
                          return ContinueButton(
                            text: 'Save Address Details',
                            isValid: true,
                            isLoading: addressProvider.isLoading,
                            onTap: () {
                              _addressSave(addressProvider,
                                  _houseNumberController, _flatController);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmLocation() {
    if (_isServiceAvailable || widget.addressId != null) {
      _showSaveAddressBottomSheet();
    } else {
      showToast('Service is not available at this location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 15,
            ),
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(223, 0, 179, 6),
                  size: 40,
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Move the pin to place accurately",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 180,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              backgroundColor: Colors.white,
              child: _isLoadingLocation
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _currentAddress.split(',')[0],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: _showSearchBottomSheet,
                          child: SmallText(
                            text: "Change",
                            size: 16,
                            color: const Color.fromARGB(227, 76, 175, 79),
                            fontweights: FontWeight.w500,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentAddress,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isServiceAvailable || widget.addressId != null
                                ? const Color(0xFF33C362)
                                : Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.addressId != null
                            ? "Confirm Updated Location"
                            : "Confirm Location",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isServiceAvailable || widget.addressId != null
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _houseNumberController.dispose();
    _flatController.dispose();
    super.dispose();
  }
}
