import 'package:flutter/material.dart';

import 'QR_Scan/QR_App.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

TabBar get _tabBar => TabBar(
      tabs: [
        Tab(text: "Exams"),
        Tab(text: "Topics"),
        Tab(text: "Alerts"),
      ],
      indicatorColor: Colors.red,
      indicatorWeight: 4.0,
    );

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.lightBlueAccent,
                child: _tabBar,
              ),
            ),
            title: const Text(
              "AlwarTeam.Com",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide()),
                            labelText: 'Enter Your Referral Code',
                            hintText: 'Enter Your Referral Code'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        child: Text("Submit Referral Code"),
                        onPressed: () {
             //             Navigator.push(
               //             context,
                //            MaterialPageRoute(builder: (context) => const HomeScreen()),
                  //        );
                        }),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        child: Text("Scan QR Code"),
                        onPressed: () {
                                       Navigator.push(
                                       context,
                                      MaterialPageRoute(builder: (context) => const OtpMyHome()),
                                  );
                        }),
                  ],
                ),
              ),
              Center(child: Text('Post Related to Topics')),
              Center(child: Text('Post Related to Alerts')),
            ],
          ),
        ),
      ),
    );
  }
}
