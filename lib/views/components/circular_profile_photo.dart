import 'package:flutter/material.dart';
import 'package:verve/views/constants/asset_files.dart';

Widget circularProfilePhoto(
  String photo,
  double size,
) {
  return Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
        radius: 100 * (size / 100),
      ),
      ClipOval(
        child: FadeInImage.assetNetwork(
          width: 180 * (size / 100),
          height: 180 * (size / 100),
          placeholder: AssetFiles.userPlaceholderImage,
          image: photo,
          imageErrorBuilder: (context, error, stackTrace) =>
              Image.asset(AssetFiles.userPlaceholderImage),
        ),
      ),
    ],
  );
}
