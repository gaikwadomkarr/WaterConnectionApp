import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:waterconnection/UI/AllEntriesPage.dart';
import 'package:waterconnection/UI/MeterReadingsPage.dart';
import 'package:waterconnection/UI/custom_tab_bar.dart';

class Entries extends StatefulWidget {
  const Entries({Key key}) : super(key: key);

  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              // color: theme.appBarTheme.color,
              color: Colors.green[900],
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                physics: CustomTabBarScrollPhysics(),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.grey[400],
                labelColor: Colors.green[900],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 45.0,
                  indicatorColor: Colors.white,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                controller: _tabController,
                isScrollable: false,
                tabs: [
                  Tab(
                    child: Text(
                      'Connections',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Water Meter',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: CustomTabBarScrollPhysics(),
                controller: _tabController,
                children: [AllEntriesPage(), MeterReadingsPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
