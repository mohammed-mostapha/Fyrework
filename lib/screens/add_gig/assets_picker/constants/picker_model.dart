import 'package:flutter/material.dart';
import '../src/wechat_assets_picker.dart';

class PickMethodModel {
  const PickMethodModel({
    this.icon,
    this.name,
    this.description,
    this.method,
  });

  final String icon;
  final String name;
  final String description;
  final Future<List<AssetEntity>> Function(BuildContext, List<AssetEntity>)
      method;

  static PickMethodModel common = PickMethodModel(
    method: (
      BuildContext context,
      List<AssetEntity> assets,
    ) async {
      return await AssetPicker.pickAssets(
        context,
        maxAssets: 5,
        pathThumbSize: 84,
        gridCount: 4,
        selectedAssets: assets,
        requestType: RequestType.image,
      );
    },
  );
}
