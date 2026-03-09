import 'package:pos_billing/common/singletons/numberformat_handler.dart';

extension KdNumExt on num {
  String get formatToDouble {
    return this != 0 ? NumberformatHandler.format(this, "#######.##") : '';
  }

  String get formatToDoubleWithZero {
    return this != 0 ? NumberformatHandler.format(this, "#######.##") : '0';
  }

  String get thousentTextByStr {
    return this != 0 ? NumberformatHandler.format(this, "##,##,###.##") : '';
  }

  String thousandText([bool isIndian = true]) {
    if (isIndian) {
      return NumberformatHandler.format(this, "##,##,###.##");
    } else {
      return NumberformatHandler.format(this, "###,###,###.##");
    }
  }

  String get thousandText3Digit {
    return NumberformatHandler.format(this, "##,##,###.###");
  }

  String get normalText {
    return NumberformatHandler.format(this, "#.##");
  }

  String get normalTextSinglePlace {
    return NumberformatHandler.format(this, "#.#");
  }

  String nonZeroString() => this == 0 ? "" : normalText;

  int get mobileLenWithFormatter => toInt() + ((this / 5).ceil() - 1);

  bool isBetween(num lower, num upper) {
    return (this >= lower && this <= upper);
  }

  bool isNotBetween(num lower, num upper) {
    return !isBetween(lower, upper);
  }

  String distanceText([int places = 2]) {
    if (this > 0) {
      if (this >= 1000) {
        return "${(this * 0.001).toStringAsFixed(places)} KM.";
      }
      return "${toStringAsFixed(places)} Mt.";
    }
    return "--";
  }
}
