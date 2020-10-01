import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import '../../wechat_assets_picker.dart';

class ImagePageBuilder extends StatelessWidget {
  const ImagePageBuilder({
    Key key,
    this.asset,
    this.state,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// [State] for asset picker viewer.
  /// 资源查看器的状态[State]
  final AssetPickerViewerState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: state.switchDisplayingDetail,
      child: ExtendedImage(
        image: AssetEntityImageProvider(asset),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        onDoubleTap: state.updateAnimation,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            initialScale: 1.0,
            minScale: 1.0,
            maxScale: 3.0,
            animationMinScale: 0.6,
            animationMaxScale: 4.0,
            cacheGesture: false,
            inPageView: true,
          );
        },
        loadStateChanged: state.previewWidgetLoadStateChanged,
      ),
    );
  }
}
