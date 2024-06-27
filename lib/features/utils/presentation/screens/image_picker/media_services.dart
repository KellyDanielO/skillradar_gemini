
import 'package:photo_manager/photo_manager.dart';

class MediaServices {

  Future loadAlbums(RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albulmList = [];
    
    if (permission.isAuth == true) {
      albulmList = await PhotoManager.getAssetPathList(
        type: requestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albulmList;
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
      start: 0,
      end: await selectedAlbum.assetCountAsync,
    );
    return assetList;
  }
}