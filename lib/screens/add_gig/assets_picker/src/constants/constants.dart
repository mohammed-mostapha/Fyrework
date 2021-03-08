import 'constants.dart';

export 'package:flutter_common_exports/flutter_common_exports.dart';

export '../delegates/sort_path_delegate.dart';
export '../delegates/text_delegate.dart';

export 'custom_scroll_physics.dart';

class Constants {
  const Constants._();

  static TextDelegate textDelegate = DefaultTextDelegate();
  static SortPathDelegate sortPathDelegate = SortPathDelegate.common;
}
