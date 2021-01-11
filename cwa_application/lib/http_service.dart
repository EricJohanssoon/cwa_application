import 'dart:convert';
import 'dart:core';

import 'package:cwa_application/aboutpage_model.dart';
import 'package:cwa_application/event_model.dart';
import 'package:cwa_application/sponsors_model.dart';
import 'package:cwa_application/ticket_model.dart';
import 'package:http/http.dart';

enum RegisterReturn {
  success,
  wrongEmail,
  missingField_email,
  missingField_phoneNumber,
  missingField_fullName,
  missingField_programmeAndYearOfAdmission,
  accountAlreadyExist,
  unknown_error
}

enum ContactReturn {
  success,
  missingField_subject,
  missingField_message,
  unknown_error
}

enum TicketStatus {
  available,
  owned_not_throwable,
  owned_throwable,
  event_full,
  event_outdated
}

class HttpService {


  final String _postsURL = "https://www.cwa-chalmers.se/_functions/events";
  final String _registerURL = "https://www.cwa-chalmers.se/_functions/addMember";
  final String _loginURL = "https://www.cwa-chalmers.se/_functions/login";
  final String _getTicketsURL = "https://www.cwa-chalmers.se/_functions/getTickets";
  final String _deleteTicketURL = "https://www.cwa-chalmers.se/_functions/deleteTicket";
  final String _addTicketURL = "https://www.cwa-chalmers.se/_functions/addTicket";
  final String _memberInfoURL = "https://www.cwa-chalmers.se/_functions/memberInfo";
  final String _getAboutTextURL = "https://www.cwa-chalmers.se/_functions/getAboutPageText";
  final String _getSponsorsURL = "https://www.cwa-chalmers.se/_functions/getSponsors";
  final String _sendMessageURL = "https://www.cwa-chalmers.se/_functions/sendMessage";
  final String _getTicketStatusURL = "https://www.cwa-chalmers.se/_functions/checkTicketAvailability";
  final String _deleteTicket2URL = "https://www.cwa-chalmers.se/_functions/deleteTicket2";
  final String _getPrivacyPolicyURL = "https://www.cwa-chalmers.se/_functions/privacyPolicy";

  Future<List<Event>> getEvents() async {
    Response res = await post(_postsURL);
    List<Event> events = new List<Event>();
    if (res.statusCode == 200) {
      print('Response status: ${res.statusCode}');
      //print('Response body: ${res.body}');
      List<dynamic> json_list = jsonDecode(res.body)['events'] as List<dynamic>;
      for (dynamic object in json_list) {
        events.insert(0, Event.fromJson(object));
      }
    }
    return events;
  }

  Future<List<RegisterReturn>> register(String email, String phoneNumber,
      String fullName, String programmeAndYearOfAdmission, bool memberOfStudentUnion, bool studentAlumniEmployeeAtChalmers, bool agreeToPrivacyPolicy) async {
    List<RegisterReturn> registerReturn = List<RegisterReturn>();

    Response response = await post(_registerURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          //important to have _id since wix is checking if an object with the same _id property is present in a database collection in the WixData.update() method
          'email': email,
          'phone': phoneNumber,
          'firstName': fullName,
          'address': programmeAndYearOfAdmission,
          "memberOfStudentUnion" : memberOfStudentUnion,                //har samma namn som vår databas
          "kryssrutaForVillkor" : studentAlumniEmployeeAtChalmers,  //kryssrutaForVillkor i cwa's databas
          "kryssrutaForVillkor2" : agreeToPrivacyPolicy     //kryssrutaForVillkor2 i cwa's databas
        }));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      //if success
      if (jsonObject['inserted'] == true) {
        registerReturn.add(RegisterReturn.success);
        return registerReturn;
      }

    } else {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      if (jsonObject.containsKey('error')) {
        dynamic errorObject = jsonObject['error'];
        int errorType = errorObject['errorType'];
        switch (errorType) {
          case 1:
            {
              if (errorObject['emailIsMissing'] == true) {
                registerReturn.add(RegisterReturn.missingField_email);
              }
              if (errorObject['phoneNumberIsMissing'] == true) {
                registerReturn.add(RegisterReturn.missingField_phoneNumber);
              }
              if (errorObject['fullNameIsMissing'] == true) {
                registerReturn.add(RegisterReturn.missingField_fullName);
              }
              if (errorObject['programmeAndYearOfAdmissionIsMissing'] == true) {
                registerReturn.add(
                    RegisterReturn.missingField_programmeAndYearOfAdmission);
              }
            }
            break;

          case 2:
            {
              registerReturn.add(RegisterReturn.wrongEmail);
            }
            break;

          case 3:
            {
              registerReturn.add(RegisterReturn.accountAlreadyExist);
            }
            break;

          default:
            {}
            break;
        }
        return registerReturn;
      } else {
        registerReturn.add(RegisterReturn.unknown_error);
        print(response.body);
        return registerReturn;
      }
    }
  }

  Future<List<ContactReturn>> sendMessage(
      String member, String subject, String message) async {
    List<ContactReturn> contactReturn = List<ContactReturn>();

    Response response = await post(_sendMessageURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          //important to have _id since wix is checking if an object with the same _id property is present in a database collection in the WixData.update() method
          'member': member,
          'subject': subject,
          'message': message
        }));

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      //if success
      if (jsonObject['success'] == true) {
        contactReturn.add(ContactReturn.success);
        return contactReturn;
      } else {
        contactReturn.add(ContactReturn.unknown_error);
        return contactReturn;
      }
    } else {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      if (jsonObject.containsKey('error')) {
        dynamic errorObject = jsonObject['error'];
        if (errorObject['subjectIsMissing'] == true) {
          contactReturn.add(ContactReturn.missingField_subject);
        }
        if (errorObject['messageIsMissing'] == true) {
          contactReturn.add(ContactReturn.missingField_message);
        }
        return contactReturn;
      }
    }
  }

  Future<String> login(String email, String phoneNumber) async {
    Response response = await post(_loginURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'email': email,
          'phoneNumber': phoneNumber,
        }));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> member = jsonDecode(response.body);
      return member['_id'];
    } else {
      return null;
    }
  }

  Future<List<Ticket>> getTickets(String memberId) async {
    Response res = await put(_getTicketsURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{'member': memberId}));
    List<Ticket> tickets = new List<Ticket>();
    if (res.statusCode == 200) {
      //print('Response status: ${res.statusCode}');
      //print('Response body: ${res.body}');
      List<dynamic> json_list =
          jsonDecode(res.body)['tickets'] as List<dynamic>;
      for (dynamic object in json_list) {
        Event event = Event.fromJson(object['event']);
        tickets.insert(0, Ticket.fromJson(object, event));
      }
    }
    return tickets;
  }

  Future<bool> deleteTicket(String ticketId) async {
    Response res = await put(_deleteTicketURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{'ticket': ticketId}));

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Ticket> addTicket(String eventId, String memberId) async {
    Response res = await post(_addTicketURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, Object>{'member': memberId, 'event': eventId}));

    //print('Response status: ${res.statusCode}');
    //print('Response body: ${res.body}');

    if (res.statusCode == 201) {
      dynamic object = jsonDecode(res.body);
      Event event = Event.fromJson(object['ticket']['event']);
      Ticket ticket = Ticket.fromJson(object['ticket'], event);
      return ticket;
    } else
      return null;
  }

  Future<Set<String>> getMemberInfo(String memberId) async {
    Response res = await post(_memberInfoURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{'member': memberId}));

    if (res.statusCode == 200) {
      String name = jsonDecode(res.body)['name'] as String;
      String email = jsonDecode(res.body)['email'] as String;

      return {name, email};
    } else{
      return null;
    }
  }

  Future<AboutPage> getAboutPageText() async {
    Response res = await get(_getAboutTextURL);

    if (res.statusCode == 200) {
      AboutPage aboutPageText;
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      aboutPageText = AboutPage.fromJson(jsonDecode(res.body)['about']);
      return aboutPageText;
    } else {
      return null;
    }
  }

  Future<List<Sponsor>> getSponsors() async {
    List<Sponsor> sponsors = new List<Sponsor>();
    Response res = await get(_getSponsorsURL);
    if (res.statusCode == 200) {
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      List<dynamic> json_list =
          jsonDecode(res.body)['sponsors'] as List<dynamic>;
      for (dynamic object in json_list) {
        sponsors.insert(0, Sponsor.fromJson(object));
      }
    }
    return sponsors;
  }

  Future<TicketStatus> getTicketStatus(String eventId, String memberId) async {
    Response res = await put(_getTicketStatusURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'event': eventId,
          'member': memberId,
        }));

    //print('Response status: ${res.statusCode}');
    //print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      bool ticketExist = json['ticketExist'] as bool;
      bool eventStartWithin24h = json['eventStartWithin24h'] as bool;
      bool eventOutdated = json['eventOutdated'] as bool;
      bool eventFull = json['eventFull'] as bool;

      if (eventOutdated) {
        return TicketStatus.event_outdated;
      } else if (ticketExist && eventStartWithin24h) {
        return TicketStatus.owned_not_throwable;
      } else if (ticketExist) {
        return TicketStatus.owned_throwable;
      } else if (eventFull) {
        return TicketStatus.event_full;
      } else {
        return TicketStatus.available;
      }
    }
  }

  Future<bool> deleteTicket2(String eventId, String memberId) async {
    Response res = await put(_deleteTicket2URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'event': eventId,
          'member': memberId,
        }));

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['deleted'] as bool;
    } else {
      return false;
    }
  }



  Future<String> getPrivacyPolicyLink() async{
    Response res = await get(_getPrivacyPolicyURL);
    String privacyPolicyLink = "";
    if (res.statusCode == 200) {
      //print('Response status: ${res.statusCode}');
      //print('Response body: ${res.body}');
      privacyPolicyLink = jsonDecode(res.body)['privacyPolicy'] as String;
    }
    return privacyPolicyLink;
  }
}

