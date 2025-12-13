import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/model/app_bar_bundle.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/widgets/side_bar.dart';
import 'package:nj_pizza_delivery/app/home/widgets/appBar/widgets/top_bar.dart';

AppBarBundle appBarBundle() {
  return AppBarBundle(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(65),
      child: SafeArea(child: TopBarWidget()),
    ),
    drawer: SideMenuWidget(),
  );
}
