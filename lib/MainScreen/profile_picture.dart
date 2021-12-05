import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      mouseCursor: SystemMouseCursors.basic,
      onHover: (hovering) => {
        setState(() {
          this.hovering = hovering;
        })
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: CircleAvatar(
          radius: hovering ? 180 : 150,
          backgroundImage: const CachedNetworkImageProvider(
            "https://i.imgur.com/BBsl598.jpg",
          ),
        ),
      ),
    );
  }
}
