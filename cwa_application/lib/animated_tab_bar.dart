import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedTabBar extends StatelessWidget {
  TabController tabController;

  AnimatedTabBar({@required this.tabController});

  @override
  Widget build(BuildContext context) {
    return tabController != null ? TabBar(
      controller: tabController,
      tabs: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
          children: [
            Tab(
                icon: new Icon(
              FeatherIcons.compass, size: 20,
              //FeatherIcons.globe
            )),
            Tab(
              icon: new Icon(
                FeatherIcons.tag, size: 20,
                //FeatherIcons.creditCard
              ),
            ),
            Tab(
              icon: new Icon(
                FeatherIcons.info,
                size: 20,
              ),
            ),
            Tab(
              icon: new Icon(
                FeatherIcons.user,
                size: 20,
              ),
            )
          ]),
      labelColor: Color(0xFF6740FB),
      unselectedLabelColor: Color(0xFFAAAAAA),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Color(0xFF6740FB),
    ): Container(width: 0, height: 0,);
  }
}
