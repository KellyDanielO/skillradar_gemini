
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import 'media_services.dart';

class MediaPicker extends StatefulWidget {
  final int maxCount;
  final RequestType requestType;
  const MediaPicker(this.maxCount, this.requestType, {super.key});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albulmList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];

  @override
  void initState() {
    MediaServices().loadAlbums(widget.requestType).then((v) {
      List<AssetPathEntity> value = v;
      if (v.isEmpty) {
        // Get.snackbar(
        //   "Error",
        //   "No album found",
        //   backgroundColor: Colors.redAccent,
        //   colorText: Colors.white,
        // );
        Navigator.pop(context);
      } else {
        setState(() {
          albulmList = value;
          selectedAlbum = value[0];
        });
        // load recent assets
        MediaServices().loadAssets(selectedAlbum!).then((value) {
          setState(() {
            assetList = value;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = StateInheritedWidget.of(context);
    double width = MediaQuery.of(context).size.width;
    double dfs = width * .01 + 16;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color:AppColors.whiteColor,
            ),
          ),
          title: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * .3),
            child: DropdownButton<AssetPathEntity>(
              value: selectedAlbum,
              iconEnabledColor: AppColors.whiteColor,
              dropdownColor: AppColors.blackColor,
              underline: const Text(''),
              isExpanded: true,
              onChanged: (AssetPathEntity? value) {
                setState(() {
                  selectedAlbum = value;
                });
                MediaServices().loadAssets(selectedAlbum!).then((value) {
                  setState(() {
                    assetList = value;
                  });
                });
              },
              items: albulmList.map<DropdownMenuItem<AssetPathEntity>>(
                  (AssetPathEntity album) {
                return DropdownMenuItem<AssetPathEntity>(
                    value: album,
                    child: Text(
                      album.name,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                      ),
                    ));
              }).toList(),
            ),
          ),
          actions: [
            selectedAssetList.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context, selectedAssetList);
                    },
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: dfs - 6,
                              fontFamily: AppFonts.sansFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const Text(''),
          ],
        ),
        body: assetList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: assetList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  AssetEntity assetEntity = assetList[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: assetWidget(assetEntity),
                  );
                },
              ),
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                selectAsset(assetEntity: assetEntity);
              },
              child: Padding(
                padding: EdgeInsets.all(
                    selectedAssetList.contains(assetEntity) == true ? 10 : 0),
                child: AssetEntityImage(
                  assetEntity,
                  isOriginal: false,
                  thumbnailSize: const ThumbnailSize.square(250),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (assetEntity.type == AssetType.video)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.video_call,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  selectAsset(assetEntity: assetEntity);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedAssetList.contains(assetEntity) == true
                          ? AppColors.primaryColor
                          : Colors.black12,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${selectedAssetList.indexOf(assetEntity) + 1}",
                        style: TextStyle(
                          color: selectedAssetList.contains(assetEntity) == true
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  void selectAsset({
    required AssetEntity assetEntity,
  }) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else if (selectedAssetList.length < widget.maxCount) {
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }
}