import 'package:flutter/material.dart';
import 'package:kintaikei_app/common/style.dart';
import 'package:kintaikei_app/providers/login.dart';
import 'package:kintaikei_app/widgets/date_time_widget.dart';
import 'package:kintaikei_app/widgets/group_dropdown.dart';
import 'package:kintaikei_app/widgets/info_label.dart';
import 'package:kintaikei_app/widgets/stamp_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  const CircleAvatar(
                    backgroundColor: kGrey300Color,
                    child: Text(
                      '屋',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const DateTimeWidget(),
                          SizedBox(height: 16),
                          InfoLabel(
                            label: '出勤先を選んでください',
                            child: GroupDropdown(
                              value: null,
                              groups: [],
                              onChanged: (value) {},
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: StampButton(
                                  label: '退勤する',
                                  labelColor: kWhiteColor,
                                  backgroundColor: kBlueColor,
                                  onPressed: () async {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text('今日の予定'),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kMainColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '00:00〜00:00',
                                        style: const TextStyle(
                                          color: kWhiteColor,
                                          fontSize: 18,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        'aa',
                                        style: const TextStyle(
                                          color: kWhiteColor,
                                          fontSize: 18,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'agas',
                                    style: const TextStyle(
                                      color: kWhiteColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundColor: kGrey300Color,
                    child: Text(
                      '屋',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: kGrey300Color,
                    child: Text(
                      '屋',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // return FutureBuilder(
    //   future: homeProvider.initGroup(loginProvider.groups),
    //   builder: (context, snapshot) {
    //     return Scaffold(
    //       body: SafeArea(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                     child: GroupDropdown(
    //                       value: homeProvider.currentGroup,
    //                       groups: loginProvider.groups,
    //                       onChanged: (value) => homeProvider.changeGroup(value),
    //                     ),
    //                   ),
    //                   homeProvider.currentGroup != null
    //                       ? ShiftButton(
    //                           onTap: () => showBottomUpScreen(
    //                             context,
    //                             ShiftScreen(
    //                               loginProvider: loginProvider,
    //                               group: homeProvider.currentGroup,
    //                             ),
    //                           ),
    //                         )
    //                       : Container(),
    //                 ],
    //               ),
    //             ),
    //             StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //               stream: planService.streamList(
    //                 group: homeProvider.currentGroup,
    //                 userId: loginProvider.user?.id,
    //               ),
    //               builder: (context, snapshot) {
    //                 List<Appointment> appointments =
    //                     planService.convertList(snapshot);
    //                 return HomeCalendar(
    //                   dataSource: _DataSource(appointments),
    //                   controller: calendarController,
    //                   onLongPress: (CalendarLongPressDetails details) {
    //                     if (homeProvider.currentGroup != null) return;
    //                     showBottomUpScreen(
    //                       context,
    //                       PlanAddScreen(
    //                         loginProvider: loginProvider,
    //                         homeProvider: homeProvider,
    //                         date: details.date ?? DateTime.now(),
    //                       ),
    //                     );
    //                   },
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //       bottomNavigationBar: Container(
    //         decoration: const BoxDecoration(
    //           border: Border(
    //             top: BorderSide(color: kGrey300Color),
    //           ),
    //         ),
    //         child: BottomNavigationBar(
    //           onTap: (value) {
    //             switch (value) {
    //               case 0:
    //                 break;
    //               case 1:
    //                 showBottomUpScreen(
    //                   context,
    //                   StampScreen(
    //                     loginProvider: loginProvider,
    //                     homeProvider: homeProvider,
    //                   ),
    //                 );
    //                 break;
    //               case 2:
    //                 showBottomUpScreen(
    //                   context,
    //                   UserScreen(
    //                     loginProvider: loginProvider,
    //                     homeProvider: homeProvider,
    //                   ),
    //                 );
    //                 break;
    //             }
    //           },
    //           items: [
    //             const BottomNavigationBarItem(
    //               icon: Icon(Icons.list),
    //               label: '申請',
    //             ),
    //             const BottomNavigationBarItem(
    //               icon: Icon(Icons.add),
    //               label: '打刻',
    //             ),
    //             BottomNavigationBarItem(
    //               icon: const Icon(Icons.person),
    //               label: loginProvider.user?.name ?? '',
    //             ),
    //           ],
    //         ),
    //       ),
    //       floatingActionButtonLocation:
    //           FloatingActionButtonLocation.centerDocked,
    //       floatingActionButton: FloatingActionButton(
    //         backgroundColor: buttonBackColor,
    //         onPressed: () => showBottomUpScreen(
    //           context,
    //           StampScreen(
    //             loginProvider: loginProvider,
    //             homeProvider: homeProvider,
    //           ),
    //         ),
    //         child: Icon(
    //           Icons.add,
    //           color: buttonLabelColor,
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
