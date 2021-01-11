import 'package:cwa_application/http_service.dart';
import 'package:cwa_application/ticket_card.dart';
import 'package:cwa_application/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TicketView extends StatefulWidget {
  Key key;
  String memberId;
  TicketView({@required this.memberId, @required this.key});

  @override
  TicketViewState createState() => TicketViewState(memberId: memberId);
}

class TicketViewState extends State<TicketView> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  HttpService httpService = HttpService();
  String memberId;
  List<Ticket> tickets;

  TicketViewState({@required this.memberId});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      left: false,
      right: false,
      child: Container(
        color: Colors.black,
        child: Column(children: <Widget>[
          Flexible(
              child: FutureBuilder(
                  future: httpService.getTickets(memberId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          height *
                                              0.02),
                                  child: Icon(
                                    AntDesign.frowno,
                                    size: 32,
                                    color: Color(0xFFDCDCDC),
                                  ),
                                ),
                                Text(
                                  'You have no tickets, check out events!',
                                  style: TextStyle(
                                      color: Color(0xFFDCDCDC),
                                      fontFamily: 'Ginto'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      tickets = snapshot.data as List<Ticket>;
                      tickets.sort((a, b) => a.compareTo(b));
                      return AnimatedList(
                          key: _key,
                          initialItemCount: tickets.length + 1,
                          itemBuilder: (context, index, animation) {
                            if (index == 0) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: height *
                                        0.02,
                                    bottom: height *
                                        0.02),
                                child: Text(
                                  "Tickets",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Ginto',
                                      color: Color(0xFFDCDCDC)),
                                ),
                              );
                            }
                            index -= 1;

                            return buildItem(tickets[index], animation, index);
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF6740FB))));
                  })),
        ]),
      ),
    );
  }

  Widget buildItem(Ticket ticket, Animation<double> animation, int index) {
    return SizeTransition(
      key: UniqueKey(),
      sizeFactor: animation,
      child: TicketCard(
        memberId: memberId,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        ticket: ticket,
        deleteTicket: () {
          setState(() {
            removeItem(index);
          });
        },
      ),
    );
  }

  void removeItem(int index) {
    Ticket removedItem = tickets.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
  }
}
