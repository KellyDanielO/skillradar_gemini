import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageurl;
  final BoxFit? fit;
  const CustomNetworkImage({super.key, required this.imageurl, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primaryColor,
        ),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.error,
          color: AppColors.redColor,
        ),
      ),
    );
  }
}
