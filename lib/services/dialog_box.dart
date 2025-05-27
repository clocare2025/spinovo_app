// import 'package:clocare/backend/api/help_support_api.dart';
// import 'package:clocare/routes/routes.dart';
// import 'package:clocare/screen/widget/custom_btn.dart';
// import 'package:clocare/screen/widget/size_box.dart';
// import 'package:clocare/screen/widget/small_text.dart';
// import 'package:clocare/utiles/themes/ColorConstants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:spinovo_app/widget/size_box.dart';
// import 'package:spinovo_app/widget/text_widget.dart';

// class DialogBoxWidget {
//   confermationBox(context) {
//     HelpSupportApi helpSupportApi = HelpSupportApi();

//     Future<void> sendData() async {
//       await helpSupportApi.callRequestCreate().then(
//         (value) {
//           if (value.status == true) {
//             statusShowing(context);
//             // showCustomSnackBar(
//             //     title: 'Call Request',
//             //     "Please wait, you will get a call from us");
//           }
//         },
//       );
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         elevation: 30,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         actionsPadding: EdgeInsets.zero,
//         shadowColor: Colors.black,
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           Container(
//             decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Padding(
//               padding: const EdgeInsets.all(22),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SmallText(
//                       text: 'Send Call Request',
//                       fontweights: FontWeight.bold,
//                       size: 18,
//                       color: Colors.black),
//                   const Height(10),
//                   Lottie.asset('asset/svg/callback.json', height: 150),
//                   const Height(6),
//                   SmallText(
//                     text:
//                         'Are you sure you want to send a call request? This action will prompt a call from the CloCare team',
//                     color: Colors.black,
//                     size: 14,
//                     overFlow: TextOverflow.visible,
//                     textAlign: TextAlign.center,
//                   ),
//                   const Height(15),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 40,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: CustomSmallBtn(
//                             heights: 44,
//                             bgColor: Colors.white,
//                             onTap: () {
//                               Navigator.of(context).pop();
//                             },
//                             title: 'No',
//                             titleColor: Colors.black,
//                             iconColor: const Color(0xFFC8C8C8),
//                           ),
//                         ),
//                         const Widths(15),
//                         Expanded(
//                           child: CustomSmallBtn(
//                             heights: 53,
//                             onTap: () {
//                               Navigator.pop(
//                                 context,
//                               );
//                               sendData();
//                             },
//                             title: 'Yes',
//                             borderColor: const Color(0xFF50C1FF),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Height(10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   statusShowing(context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         elevation: 30,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         actionsPadding: EdgeInsets.zero,
//         shadowColor: Colors.black,
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           Container(
//             decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Padding(
//               padding: const EdgeInsets.all(22),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SmallText(
//                       text: 'Call Request',
//                       fontweights: FontWeight.bold,
//                       size: 18,
//                       color: Colors.black),
//                   const Height(10),
//                   Lottie.asset('asset/svg/callback.json', height: 150),
//                   const Height(6),
//                   SmallText(
//                     text:
//                         "Thank you for submitting your call request. We will contact you shortly",
//                     color: Colors.black,
//                     size: 14,
//                     overFlow: TextOverflow.visible,
//                     textAlign: TextAlign.center,
//                   ),
//                   const Height(15),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 40,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: CustomSmallBtn(
//                             heights: 53,
//                             onTap: () {
//                               Navigator.pop(
//                                 context,
//                               );
//                             },
//                             title: 'OK',
//                             borderColor: const Color(0xFF50C1FF),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Height(10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   comingSoon(context, String title, String msg) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           elevation: 10,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           backgroundColor: const Color.fromARGB(255, 236, 236, 236),
//           actionsPadding: EdgeInsets.zero,
//           actionsAlignment: MainAxisAlignment.center,
//           actions: [
//             Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: title,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     Lottie.asset('asset/svg/www.json', height: 150),
//                     const Height(10),
//                     SmallText(
//                       text: msg,
//                       size: 14,
//                       textAlign: TextAlign.center,
//                       color: Colors.black,
//                       overFlow: TextOverflow.visible,
//                       fontweights: FontWeight.w400,
//                     ),
//                     const Height(20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: CustomSmallBtn(
//                               heights: 53,
//                               onTap: () {
//                                 Navigator.pop(
//                                   context,
//                                 );
//                               },
//                               title: 'Cancel',
//                               borderColor: const Color(0xFF50C1FF),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//     // showCupertinoDialog<String>(
//     //   context: context,
//     //   builder: (BuildContext context) => CupertinoAlertDialog(
//     //     title: Text(value),
//     //     content: Column(
//     //       children: [
//     //         // const Height(10),
//     //         Lottie.asset('asset/svg/www.json', height: 150),
//     //         // const Height(6),
//     //         SmallText(
//     //           text: msg,
//     //           color: Colors.black,
//     //           overFlow: TextOverflow.visible,
//     //         ),
//     //       ],
//     //     ),
//     //     actions: <Widget>[
//     //       TextButton(
//     //         onPressed: () {
//     //           Navigator.pop(
//     //             context,
//     //           );
//     //           // errormsg();
//     //         },
//     //         child: const Text('Cancel'),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }

//   payConfermationBox(
//     context, {
//     required String title,
//     required String middleMessage,
//     required String message1,
//     required String message2,
//     required String btnText,
//     required Function onTap,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         elevation: 10,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: const Color.fromARGB(255, 236, 236, 236),
//         actionsPadding: EdgeInsets.zero,
//         actionsAlignment: MainAxisAlignment.center,
//         // shape: const RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.all(Radius.circular(10))),
//         // backgroundColor: Colors.white,
//         // surfaceTintColor: Colors.transparent,
//         actions: [
//           Container(
//             decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Padding(
//               padding: const EdgeInsets.all(22),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SmallText(
//                     text: 'Order Proceed',
//                     color: Colors.black,
//                     fontweights: FontWeight.w500,
//                     size: 20,
//                   ),
//                   const Height(10),
//                   SmallText(
//                     text: title,
//                     size: 14,
//                     textAlign: TextAlign.center,
//                     color: Colors.black,
//                     overFlow: TextOverflow.visible,
//                     fontweights: FontWeight.w400,
//                   ),
//                   const Height(5),
//                   SmallText(
//                     text: middleMessage,
//                     size: 14,
//                     textAlign: TextAlign.center,
//                     color: AppColor.boxBlueColor,
//                     overFlow: TextOverflow.visible,
//                     fontweights: FontWeight.bold,
//                   ),
//                   const Height(5),
//                   SmallText(
//                     text: message1,
//                     size: 14,
//                     textAlign: TextAlign.center,
//                     color: Colors.black,
//                     overFlow: TextOverflow.visible,
//                     fontweights: FontWeight.w400,
//                   ),
//                   const Height(5),
//                   SmallText(
//                     text: message2,
//                     size: 14,
//                     textAlign: TextAlign.center,
//                     color: Colors.black,
//                     overFlow: TextOverflow.visible,
//                     fontweights: FontWeight.w400,
//                   ),
//                   const Height(10),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 40,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: CustomSmallBtn(
//                             heights: 44,
//                             bgColor: Colors.white,
//                             onTap: () {
//                               Navigator.of(context).pop();
//                             },
//                             title: 'Cancel',
//                             titleColor: Colors.black,
//                             iconColor: const Color(0xFFC8C8C8),
//                           ),
//                         ),
//                         const Widths(15),
//                         Expanded(
//                           child: CustomSmallBtn(
//                             heights: 53,
//                             onTap: () {
//                               onTap();
//                             },
//                             title: btnText,
//                             borderColor: const Color(0xFF50C1FF),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   orderPayNowBox(
//     context, {
//     required String title,
//     required String middleMessage,
//     required String message1,
//     required String message2,
//     required String btnText,
//     required Function onTap,
//   }) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: 'Order Payment',
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 22,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: message1,
//                       color: Colors.black,
//                       overFlow: TextOverflow.visible,
//                       textAlign: TextAlign.center,
//                       size: 14,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: message2,
//                       color: Colors.green,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SmallText(
//                           text: title,
//                           color: Colors.blueAccent,
//                           overFlow: TextOverflow.visible,
//                         ),
//                         const Widths(5),
//                         SmallText(
//                           text: middleMessage,
//                           color: Colors.blueAccent,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Cancel',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           onTap();
//                         },
//                         title: btnText,
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   offerBox(context, msg) {
//     showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: "Clocare Discount",
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     const Height(10),
//                     Image.asset('asset/icons/discount.png', height: 80),
//                     const Height(10),
//                     SmallText(
//                       text: msg,
//                       color: Colors.black,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                       size: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Back',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Ok',
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   subscriptionBox(context, msg) {
//     showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: "SUBSCRIPTION",
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text:
//                           "Are you sure you want to use this subscription? Once your order is placed, only 20 items will remain available in your subscription",
//                       // 'Confirm use of this subscription? Only 20 items will remain after this order',
//                       color: Colors.black,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                       size: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Back',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Confirm',
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   helpSupportBox(context, String value, String msg, String ticketNumber) {
//     showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: value,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: ticketNumber,
//                       color: Colors.blueAccent,
//                       overFlow: TextOverflow.visible,
//                       textAlign: TextAlign.center,
//                       fontweights: FontWeight.w500,
//                       size: 16,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: msg,
//                       color: Colors.black,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                       size: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Back',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           Get.offAllNamed(Routes.bottomNavigation);
//                         },
//                         title: 'Ok',
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   payErrorBox(context, String value, String msg) {
//     showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: value,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     SmallText(
//                       text: msg,
//                       color: Colors.black,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                       size: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Back',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Ok',
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   paySuccesBox(context, String value, String msg) {
//     showCupertinoDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10))),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         actions: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: value,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     SmallText(
//                       text: msg,
//                       color: Colors.black,
//                       textAlign: TextAlign.center,
//                       overFlow: TextOverflow.visible,
//                       size: 14,
//                     ),
//                   ],
//                 ),
//               ),
//               const Height(10),
//               SizedBox(
//                 width: double.infinity,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 44,
//                         bgColor: Colors.white,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Back',
//                         titleColor: Colors.black,
//                         iconColor: const Color(0xFFC8C8C8),
//                       ),
//                     ),
//                     const Widths(15),
//                     Expanded(
//                       child: CustomSmallBtn(
//                         heights: 53,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         title: 'Ok',
//                         borderColor: const Color(0xFF50C1FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   orderProceedDialog(
//     context, {
//     required String title,
//     required String message,
//     required String btnText,
//     required Function onTap,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           elevation: 10,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           backgroundColor: Colors.white,
//           title: SmallText(
//             text: title,
//             color: Colors.black,
//             fontweights: FontWeight.w500,
//             size: 20,
//           ),
//           content: SmallText(
//             text: message,
//             size: 14,
//             color: Colors.black,
//             overFlow: TextOverflow.visible,
//             fontweights: FontWeight.w400,
//           ),
//           actions: [
//             SizedBox(
//               width: double.infinity,
//               height: 40,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // CustomBtn2(
//                   //   heights: 53,
//                   //   onTap: () {},
//                   //   title: 'Cancel',
//                   // ),
//                   CustomBtn2(
//                     title: 'Cancel',
//                     titleColor: AppColor.primaryColor1,
//                     bgColor: Colors.transparent,
//                     borderColor: AppColor.primaryColor1,
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   const Widths(20),
//                   CustomBtn2(
//                     title: btnText,
//                     titleColor: AppColor.boxColor,
//                     borderColor: AppColor.primaryColor1,
//                     bgColor: AppColor.primaryColor1,
//                     onTap: () {
//                       onTap();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   customAlitBoxV2(
//     context, {
//     required String title,
//     required String message,
//     required String btnText,
//     required Function onTap,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           elevation: 10,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           backgroundColor: const Color.fromARGB(255, 236, 236, 236),
//           actionsPadding: EdgeInsets.zero,
//           actionsAlignment: MainAxisAlignment.center,
//           actions: [
//             Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: title,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: message,
//                       size: 14,
//                       textAlign: TextAlign.center,
//                       color: Colors.black,
//                       overFlow: TextOverflow.visible,
//                       fontweights: FontWeight.w400,
//                     ),
//                     const Height(20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: CustomSmallBtn(
//                               heights: 44,
//                               bgColor: Colors.white,
//                               onTap: () {
//                                 Navigator.of(context).pop();
//                               },
//                               title: 'Cancel',
//                               titleColor: Colors.black,
//                               iconColor: const Color(0xFFC8C8C8),
//                             ),
//                           ),
//                           const Widths(15),
//                           Expanded(
//                             child: CustomSmallBtn(
//                               heights: 53,
//                               onTap: () {
//                                 onTap();
//                               },
//                               title: btnText,
//                               borderColor: const Color(0xFF50C1FF),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   orderErrorDailogBox(
//     BuildContext context, {
//     required String title,
//     required String message,
//     required String btnText,
//     required Function onTap,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           elevation: 10,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           backgroundColor: const Color.fromARGB(255, 236, 236, 236),
//           actionsPadding: EdgeInsets.zero,
//           actionsAlignment: MainAxisAlignment.center,
//           actions: [
//             Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SmallText(
//                       text: title,
//                       color: Colors.black,
//                       fontweights: FontWeight.w500,
//                       size: 20,
//                     ),
//                     const Height(10),
//                     SmallText(
//                       text: message,
//                       size: 14,
//                       textAlign: TextAlign.center,
//                       color: Colors.black,
//                       overFlow: TextOverflow.visible,
//                       fontweights: FontWeight.w400,
//                     ),
//                     const Height(20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: CustomSmallBtn(
//                               heights: 53,
//                               onTap: () {
//                                 onTap();
//                               },
//                               title: btnText,
//                               borderColor: const Color(0xFF50C1FF),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
