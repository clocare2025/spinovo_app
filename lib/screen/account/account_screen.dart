import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/auth_provider.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/size_box.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    // ignore: use_build_context_synchronously
    context.go('/phone');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColors,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: "Account",
          isBack: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.person_outline,
              title: 'PROFILE',
              subtitle: 'Update personal information',
              onTap: () {
                    context.go('/profile');
              },
            ),
            _buildListTile(
              icon: Icons.block,
              title: 'BLOCKED LIST',
              subtitle: 'Manage your blocked list',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.location_on_outlined,
              title: 'ADDRESSES',
              subtitle: 'Manage saved addresses',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.description_outlined,
              title: 'POLICIES',
              subtitle: 'Terms of Use, Privacy Policy and others',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.help_outline,
              title: 'HELP & SUPPORT',
              subtitle: 'Reach out to us in case you have a question',
              onTap: () {},
            ),
            _buildListTile(
                icon: Icons.delete_outline_outlined,
                title: 'Delete Account',
                subtitle: 'Deletes all your data.',
                onTap: () {},
                isDivider: false),
            const Height(40),
            SizedBox(
              width: 150,
              height: 50,
              child: OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(174, 158, 158, 158)),
                      // padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: CustomText(
                    text: "Log Out",
                    size: 15,
                    color: Colors.red,
                  )),
            ),
            const Height(20),
            CustomText(
              text: 'App version 1.0.0',
              color: AppColor.textColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDivider = true,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: AppColor.textColor),
              title: CustomText(
                text: title,
                size: 14,
                fontweights: FontWeight.w600,
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
            isDivider
                ? const Padding(
                    padding:
                        EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 0),
                    child: Divider(
                      color: Color.fromARGB(255, 221, 221, 221),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
