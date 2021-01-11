import 'package:flutter/foundation.dart';

class AboutPage {
  final String about;
  final String business;
  final String community;
  final String academy;

  AboutPage({
    @required this.about,
    @required this.business,
    @required this.community,
    @required this.academy,
  });

  factory AboutPage.fromJson(Map<String, dynamic> json) {
    return AboutPage(
      about: json['title'] as String,
      business: json['business'] as String,
      community: json['community'] as String,
      academy: json['academy'] as String,
    );
  }
}
