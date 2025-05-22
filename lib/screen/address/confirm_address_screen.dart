// import 'package:flutter/material.dart';

// class ConfirmAddressScreen extends StatefulWidget {
//   final String address;

//   const ConfirmAddressScreen({Key? key, required this.address}) : super(key: key);

//   @override
//   _ConfirmAddressScreenState createState() => _ConfirmAddressScreenState();
// }

// class _ConfirmAddressScreenState extends State<ConfirmAddressScreen> {
//   final TextEditingController _houseNumberController = TextEditingController();
//   String _saveAs = "Home";
//   String _petsAtHome = "NO";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background map (static image placeholder, as we don't need an interactive map here)
//           Container(
//             color: Colors.grey[300], // Placeholder for the map
//             child: const Center(
//               child: Icon(Icons.map, size: 100, color: Colors.grey),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             widget.address.split(',')[0],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text(
//                             "Change",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.address,
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: _houseNumberController,
//                       decoration: InputDecoration(
//                         hintText: "House Number",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Save as",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ChoiceChip(
//                           label: const Text("Home"),
//                           selected: _saveAs == "Home",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _saveAs = "Home";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _saveAs == "Home" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         ChoiceChip(
//                           label: const Text("Home 2"),
//                           selected: _saveAs == "Home 2",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _saveAs = "Home 2";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _saveAs == "Home 2" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         ChoiceChip(
//                           label: const Text("Custom"),
//                           selected: _saveAs == "Custom",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _saveAs = "Custom";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _saveAs == "Custom" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Do you have pets at home?",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ChoiceChip(
//                           label: const Text("NO"),
//                           selected: _petsAtHome == "NO",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _petsAtHome = "NO";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _petsAtHome == "NO" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         ChoiceChip(
//                           label: const Icon(Icons.pets), // Cat icon
//                           selected: _petsAtHome == "Cat",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _petsAtHome = "Cat";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _petsAtHome == "Cat" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         ChoiceChip(
//                           label: const Icon(Icons.pets), // Dog icon
//                           selected: _petsAtHome == "Dog",
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 _petsAtHome = "Dog";
//                               });
//                             }
//                           },
//                           selectedColor: Colors.blue,
//                           labelStyle: TextStyle(
//                             color: _petsAtHome == "Dog" ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           String finalAddress = "${_houseNumberController.text}, ${widget.address}";
//                           finalAddress += "\nSaved as: $_saveAs";
//                           finalAddress += "\nPets at home: $_petsAtHome";
//                           Navigator.of(context).pop(finalAddress);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           "Save Address Details",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _houseNumberController.dispose();
//     super.dispose();
//   }
// }