import 'package:flutter/material.dart';
import 'package:spinovo_app/location/constants.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/widget/text_widget.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading:  Icon(Icons.location_on_outlined, color: AppColor.appbarColor,),
          //SvgPicture.asset("assets/icons/location_pin.svg"),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SmallText(text: location, color: Colors.black87, size: 15, overFlow: TextOverflow.ellipsis,)
            // Text(
            //   location,
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),
          ),
        ),
        const Divider(
          height: 2,
          thickness: 3,
          color: Color.fromARGB(255, 235, 235, 235),
        ),
      ],
    );
  }
}
