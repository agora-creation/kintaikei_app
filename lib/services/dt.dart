import 'package:intl/intl.dart';

class DTService {
  String convertText(String format, DateTime? date) {
    String ret = '';
    if (date != null) {
      ret = DateFormat(format, 'ja').format(date);
    }
    return ret;
  }
}
