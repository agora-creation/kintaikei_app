import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PickerService {
  Future dateTimePicker({
    required BuildContext context,
    required DateTime init,
    required String title,
    required Function(DateTime) onChanged,
  }) async {
    await showBoardDateTimePicker(
      isDismissible: false,
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: init,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages.ja(),
        showDateButton: false,
        boardTitle: title,
      ),
      radius: 8,
      onChanged: onChanged,
    );
  }

  Future<DateTime?> monthPicker({
    required BuildContext context,
    required DateTime init,
  }) async {
    return await showMonthPicker(
      context: context,
      initialDate: init,
      locale: const Locale('ja'),
    );
  }
}
