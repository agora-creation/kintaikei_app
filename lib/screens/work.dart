import 'package:flutter/material.dart';
import 'package:kintaikei_app/models/company_group.dart';
import 'package:kintaikei_app/providers/home.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/custom_footer.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';

class WorkScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const WorkScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  CompanyGroupModel? currentGroup;

  @override
  void initState() {
    currentGroup = widget.homeProvider.currentGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.loginProvider.groups.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: GroupDropdown(
                              value: currentGroup?.id,
                              groups: widget.loginProvider.groups,
                              onChanged: (value) async {
                                await widget.homeProvider.changeGroup(value);
                                setState(() {
                                  currentGroup =
                                      widget.homeProvider.currentGroup;
                                });
                              },
                            ),
                          ),
                        )
                      : Container(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
