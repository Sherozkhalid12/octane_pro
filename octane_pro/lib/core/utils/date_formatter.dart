import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat(AppConstants.dateFormat);
  static final DateFormat _dateTimeFormat =
      DateFormat(AppConstants.dateTimeFormat);
  static final DateFormat _displayDateFormat =
      DateFormat(AppConstants.displayDateFormat);
  static final DateFormat _displayDateTimeFormat =
      DateFormat(AppConstants.displayDateTimeFormat);

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  static String formatDisplayDateTime(DateTime dateTime) {
    return _displayDateTimeFormat.format(dateTime);
  }

  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }
}
