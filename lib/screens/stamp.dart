import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/functions.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/models/work.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/providers/work.dart';
import 'package:kintaikei_app/services/work.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';
import 'package:kintaikei_app/widgets/stamp_header.dart';
import 'package:provider/provider.dart';

class StampScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const StampScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<StampScreen> createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  WorkService workService = WorkService();
  WorkModel? currentWork;
  CompanyGroupModel? selectedGroup;

  void _init() async {
    WorkModel? work = await workService.selectToId(
      id: widget.loginProvider.user?.lastWorkId,
    );
    currentWork = work;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StampHeader(
                user: widget.loginProvider.user,
                groups: widget.loginProvider.groups,
                currentWork: currentWork,
                selectedGroup: selectedGroup,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
              ),
              const DateTimeWidget(),
              Column(
                children: [
                  StampButton(
                    label: '出勤する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await workProvider.start(
                        group: selectedGroup,
                        user: widget.loginProvider.user,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      widget.loginProvider.reloadData();
                      if (!mounted) return;
                      showMessage(context, '出勤しました', true);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
