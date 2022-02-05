import 'package:flutter/material.dart';
import '../src/wechat_assets_picker.dart';

class PickMethodModel {
  const PickMethodModel({
    this.method,
  });

  final Future<List<AssetEntity>> Function(BuildContext, List<AssetEntity>)
      method;
}
