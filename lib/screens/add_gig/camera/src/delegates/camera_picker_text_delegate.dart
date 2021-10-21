/// Text delegate that controls text in widgets.
/// 控制部件中的文字实现
abstract class CameraPickerTextDelegate {
  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  String confirm;

  /// Tips string above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字
  String shootingTips;
}

/// Default text delegate implements with Chinese.
/// 中文文字实现
class DefaultCameraPickerTextDelegate implements CameraPickerTextDelegate {
  factory DefaultCameraPickerTextDelegate() => _instance;

  DefaultCameraPickerTextDelegate._internal();

  static final DefaultCameraPickerTextDelegate _instance =
      DefaultCameraPickerTextDelegate._internal();

  @override
  String confirm = '确认';

  @override
  String shootingTips = 'Tap to take photo';
}

/// Default text delegate including recording implements with Chinese.
/// 中文文字实现
class DefaultCameraPickerTextDelegateWithRecording
    implements CameraPickerTextDelegate {
  factory DefaultCameraPickerTextDelegateWithRecording() => _instance;

  DefaultCameraPickerTextDelegateWithRecording._internal();

  static final DefaultCameraPickerTextDelegateWithRecording _instance =
      DefaultCameraPickerTextDelegateWithRecording._internal();

  @override
  String confirm = '确认';

  @override
  String shootingTips = 'Hold for video, tap for photo';
}

/// Default text delegate implements with English.
/// 英文文字实现
class EnglishCameraPickerTextDelegate implements CameraPickerTextDelegate {
  factory EnglishCameraPickerTextDelegate() => _instance;

  EnglishCameraPickerTextDelegate._internal();

  static final EnglishCameraPickerTextDelegate _instance =
      EnglishCameraPickerTextDelegate._internal();

  @override
  String confirm = 'Confirm';

  @override
  String shootingTips = 'Tap to take photo.';
}

/// Default text delegate including recording implements with English.
/// 英文文字实现
class EnglishCameraPickerTextDelegateWithRecording
    implements CameraPickerTextDelegate {
  factory EnglishCameraPickerTextDelegateWithRecording() => _instance;

  EnglishCameraPickerTextDelegateWithRecording._internal();

  static final EnglishCameraPickerTextDelegateWithRecording _instance =
      EnglishCameraPickerTextDelegateWithRecording._internal();

  @override
  String confirm = 'Confirm';

  @override
  String shootingTips = 'Tap to take photo. Long press to record video.';
}
