import 'package:flutter/material.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/screen/account/privacy_policy_screen.dart';
import 'package:spinovo_app/widget/size_box.dart';

class TermConditionsScreen extends StatefulWidget {
  const TermConditionsScreen({
    super.key,
  });

  @override
  State<TermConditionsScreen> createState() => _TermConditionsScreenState();
}

class _TermConditionsScreenState extends State<TermConditionsScreen> {
  List<Map<String, dynamic>> privacyList = [
    {
      "id": 0,
      "title": "Terms & Conditions",
      "des":
          """CLOCARE VENTURED PVT. LTD. and (“CLOCARE”, “We” or “Us”) operate this app titled Clocare, (the “Mobile App”). Please carefully read these Terms of Use before using the app. By using this app, you agree that you have read and agree to the Terms of Use (this “Agreement”). If you do not agree to this Agreement, you must immediately stop using the app and avoid using any features from the APP.

This Agreement will be available in the primary languages of the countries in which we operate, but the controlling version of this Agreement is in the English language. This Agreement is made between CLOCARE and YOU or, in the case that you represent and are using the app on behalf of a company or other body, that company or other body (in either case, “You”)."""
    },
    {
      "id": 1,
      "title": "1. Acceptance of Terms",
      "des":
          """Your access to and use of Clocare is subject exclusively to these Terms and Conditions. You will not use the APP for any purpose that is unlawful or prohibited by these Terms and Conditions. By using the APP, you are fully accepting the terms, conditions, and disclaimers contained in this notice."""
    },
    {
      "id": 2,
      "title": "2. Advice",
      "des":
          """The contents of the app do not constitute advice and should not be relied upon in making, or refraining from making any decision."""
    },
    {
      "id": 3,
      "title": "3. Pickup & Delivery",
      "des":
          """Pickup and delivery will be done by Clocare as per scheduled time, but we are not guaranteed to match your scheduled pickup and delivery time, it maybe varies little as per the availability of pickup/delivery person and climate & traffic situations. Clocare is not responsible for any kind of reimbursement or refund in case of delay in pickup/delivery."""
    },
    {
      "id": 4,
      "title": "4. Order Cancellation",
      "des":
          """You can cancel your order till order is not assigned to pickup person, after that you are not able to cancel the order from the app. In that case, you are not eligible for full refund. At any given point, Clocare has the right to cancel your order without any notice."""
    },
    {
      "id": 5,
      "title": "5. Refund",
      "des":
          """No refunds shall be made, neither full nor partial, for services or packages used or consumed. The refund of unconsumed amount on packages will be at the sole discretion of the management."""
    },
    {
      "id": 6,
      "title": "6. Garment Safety",
      "des":
          """After collection of garments, We will not guarantee complete safety of your garments, but we will try to maintain the safety of your garments while Ironing Or Laundry. 

 

In case of damage/lost at Clocare, we will reimburse according to our insurance policy and our executive will give a callback to you for reimbursement discussion."""
    },
    {
      "id": 7,
      "title": "7. Promotional Use",
      "des":
          """We may use your information for suggesting promotional offers and schemes. You may update your profiling information at any time on Clocare. You acknowledge and agree such update is for your interests and for improving personalization and service efficiency of Clocare."""
    },
    {
      "id": 8,
      "title": "8. Changes to APP",
      "des":
          """Clocare reserves the right to change or remove (temporarily or permanently) the app or any feature of it without notice, and you confirm that Clocare shall not be liable to you for any such change or removal. Clocare also reserves the right to change the Terms and Conditions at any time. Your continuous use of the app following any changes shall be deemed to be your acceptance of any such change."""
    },
    {
      "id": 9,
      "title": "9. Copyright",
      "des":
          """All copyright, trademarks, and all other intellectual property rights on the Website and its content (including App design, text, graphics, illustration, data, and all software and source codes of the app) are owned by or licensed to Clocare or otherwise used by Clocare as permitted by law.


In using the app, you agree that you will access the content, pictures and other data solely for your personal and non-commercial use. None of the content may be downloaded, reproduced, transmitted, stored, sold or distributed without the permission of the copyright holder."""
    },
    {
      "id": 10,
      "title": "10. Disclaimers and Limitation of Liability",
      "des":
          """Your use of our app is at your own risk. This app contains mistakes and inaccuracies. Neither Clocare nor any other party involved in the creation of this APP shall be liable for any direct, indirect, special, incidental, consequential or punitive damages arising out of or connected in any manner with your access to or use of this app including, without limitation, any lost profits, business interruption, or loss of programs or information, even if strong well has been specifically advised of the possibility of such damages.


The APP is provided on “AS IS” and “AS AVAILABLE” basis without any representation or endorsement made and without warranty of any kind whether express or implied, including but not limited to the implied warranties of satisfactory quality, fitness for a particular purpose, non-infringement, compatibility, security, and accuracy.


To the extent permitted by law, Clocare will not be liable for any indirect or consequential loss or damage whatever (including without limitation loss of business, opportunity, data, profits) arising out of or in connection with the use of the APP.


Clocare makes no warranty that the functionality of the app will be uninterrupted or error free, that defects will be corrected or that the app or the server that makes it available are free of viruses or anything else, which may be harmful or destructive."""
    },
    {
      "id": 11,
      "title": "11. Indemnification",
      "des":
          """You agree to indemnify and hold Clocare and its employees and agents harmless from and against all liabilities, legal fees, damages, losses, costs and other expenses in relation to any claims or actions brought against Clocare arising out of any breach by you of these Terms and Conditions or other liabilities arising out of your use of this Website."""
    },
    {
      "id": 12,
      "title": "12. Severance",
      "des":
          """Severance, if any of these Terms and Conditions should be determined to be invalid, illegal, or unenforceable for any reason by any court of competent jurisdiction, then such Term or Condition shall be severed and the remaining Terms and Conditions shall survive and remain in full force and effect and continue to be binding and enforceable."""
    },
    {
      "id": 13,
      "title": "13. Governing Law",
      "des":
          """These Terms and Conditions shall be governed by and construed in accordance with the Constitutional Law of Canada, and you hereby submit to the exclusive jurisdiction of the Federal Court."""
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Terms of Use",
          isBack: true,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView.builder(
              itemCount: privacyList.length,
              itemBuilder: (BuildContext context, int index) {
                var allData = privacyList[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Height(30),
                    TitleWidget(
                      title: allData['title'],
                    ),
                    const Height(5),
                    DescriptionWidget(
                      description: allData['des'],
                    ),
                  ],
                );
              })),
    );
  }
}
