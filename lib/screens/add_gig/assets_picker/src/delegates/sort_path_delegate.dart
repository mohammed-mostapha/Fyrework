import 'package:photo_manager/photo_manager.dart';

abstract class SortPathDelegate {
  const SortPathDelegate();

  void sort(List<AssetPathEntity> list);

  static const SortPathDelegate common = CommonSortPathDelegate();
}

class CommonSortPathDelegate extends SortPathDelegate {
  const CommonSortPathDelegate();

  @override
  void sort(List<AssetPathEntity> list) {
    list.sort((AssetPathEntity path1, AssetPathEntity path2) {
      if (path1.isAll) {
        return -1;
      }
      if (path2.isAll) {
        return 1;
      }
      if (_isCamera(path1)) {
        return -1;
      }
      if (_isCamera(path2)) {
        return 1;
      }
      if (_isScreenShot(path1)) {
        return -1;
      }
      if (_isScreenShot(path2)) {
        return 1;
      }
      return otherSort(path1, path2);
    });
  }

  int otherSort(AssetPathEntity path1, AssetPathEntity path2) {
    return path1.name.compareTo(path2.name);
  }

  bool _isCamera(AssetPathEntity entity) {
    return entity.name.toUpperCase() == 'camera'.toUpperCase();
  }

  bool _isScreenShot(AssetPathEntity entity) {
    return entity.name.toUpperCase() == 'screenshots'.toUpperCase() ||
        entity.name.toUpperCase() == 'screenshot'.toUpperCase();
  }
}
