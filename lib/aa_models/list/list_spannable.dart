import '../../models/common/image_tint.dart';

class AAListItemSpannable {
  final AutoImageTint color;

  final int start;

  final int end;

  AAListItemSpannable({required this.color, required this.start, required this.end});


  Map<String, dynamic> toJson() => {
    'start': start,
    'color': color.toJson(),
    'end': end,

  };
}