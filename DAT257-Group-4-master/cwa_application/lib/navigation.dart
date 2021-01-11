import 'dart:core';

import 'package:cwa_application/account_page.dart';
import 'package:cwa_application/animated_tab_bar.dart';
import 'package:cwa_application/event_model.dart';
import 'package:cwa_application/ticket_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cwa_application/event_card.dart';
import 'package:move_to_background/move_to_background.dart';
import 'http_service.dart';
import 'info_page.dart';

class Navigation extends StatefulWidget {
  final String memberId;
  Navigation({Key key, @required this.memberId}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState(memberId: memberId);
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin{
  List<Event> events = [];
  final HttpService httpService = HttpService();
  String memberId;
  final GlobalKey<TicketViewState> ticketViewKey =
      new GlobalKey<TicketViewState>();
  _NavigationState({@required this.memberId});
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    });
    httpService.getEvents().then((result) {
      events = result;
      events.sort((a, b) => a.compareTo(b));
      if (this.mounted) {
        setState(() {});
      }
    }).catchError((e) {
      print("inside catchError for events");
      print(e.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Scaffold(
          body: TabBarView(
            controller: tabController,
            children: [
              Column(children: <Widget>[
                Expanded(
                    child: RefreshIndicator(
                  color: Color(0xFF6740FB),
                  backgroundColor: Color(0xFFDCDCDC),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: events.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // return the header
                          return Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.02,
                                bottom: MediaQuery.of(context).size.height *
                                    0.02),
                            child: Text(
                              "Events",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Ginto',
                                  color: Color(0xFFDCDCDC)),
                            ),
                          );
                        }
                        index -= 1;

                        return EventCard(
                          memberId: memberId,
                          event: events[index],
                          key: UniqueKey(),
                        );
                      }),
                  onRefresh: () async {
                    events = await httpService.getEvents();
                    events.sort((a, b) => a.compareTo(b));
                    if (this.mounted) {
                      setState(() {});
                    }
                    return null;
                  },
                ))
              ]),
              TicketView(
                key: ticketViewKey,
                memberId: memberId,
              ),
              InfoPage(memberId: memberId,),
              AccountPage(
                memberId: memberId,
              )
            ],
          ),
          bottomNavigationBar:
              SafeArea(left: false, right: false, child: AnimatedTabBar(tabController: tabController,)),
          backgroundColor: Color(0xFF121212),
        ),
      ),
    );
  }
}
