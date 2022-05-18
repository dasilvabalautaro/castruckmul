import 'dart:async';
import 'dart:io';
import 'dart:ffi';
import 'package:castruckmul/infrastructure/plug_com.dart';
import 'package:castruckmul/view/grid_data.dart';
import 'package:castruckmul/view/login_form.dart';
import 'package:castruckmul/view/user_form_register.dart';
import 'package:castruckmul/view/weighing_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_menu/flutter_menu.dart';
import 'domain/get_data.dart';

//PlugCom plugCom = PlugCom();
GetDataUseCase db = GetDataUseCase();

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CasTruck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                Colors.blueGrey[600]), // Set Button hover color
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),

            backgroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(
                Colors.blueGrey[600]), // Set Button hover color
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Login(db: db),
    );
  }
}

/*
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Yep!" as the result.
                  Navigator.pop(context, 'Yep!');
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Nope." as the result.
                  Navigator.pop(context, 'Nope.');
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

/////////////////////
/*
class CasTruckApp extends StatelessWidget {
  const CasTruckApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CasTruck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                Colors.blueGrey[600]), // Set Button hover color
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),

            backgroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(
                Colors.blueGrey[600]), // Set Button hover color
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Screen(title: 'CasTruck Home Page'),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  String _message = "Choose a MenuItem.";
  String _drawerTitle = 'Tap a drawerItem';
  IconData _drawerIcon = Icons.menu;
  int screenSelected = 2;
  Color masterBackgroundColor = Colors.white;
  Color detailBackgroundColor = Colors.blueGrey[300] as Color;
  //late ScrollController _controller;
  final scrollController = ScrollController();
  @override
  void initState() {
    //_controller = ScrollController();
    cnn();
    super.initState();
  }

  Future<void> cnn() async {
    await db.connect();
  }

  void _showMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScreen(
        menuList: [
          MenuItem(title: 'File', menuListItems: [
            MenuListItem(
              icon: Icons.open_in_new,
              title: 'Get Into',
              onPressed: () {
                screenSelected = 1;
                masterMain();
                setState(() {});
              },
              shortcut: MenuShortcut(key: LogicalKeyboardKey.keyO, ctrl: true),
            ),
            MenuListItem(
              icon: Icons.outbond,
              title: 'Get Out',
              onPressed: () {
                screenSelected = 2;
                masterMain();
                setState(() {});
              },
            ),
            MenuListItem(
              icon: Icons.close,
              title: 'Close',
              onPressed: () {
                _showMessage('File.close');
              },
            ),
          ]),
          MenuItem(title: 'Reports', isActive: true, menuListItems: [
            MenuListItem(icon: Icons.report, title: 'Report for date'),
          ]),
          MenuItem(title: 'Help', isActive: true, menuListItems: [
            MenuListItem(icon: Icons.help, title: 'Help'),
            MenuListItem(icon: Icons.question_answer, title: 'About'),
            MenuListItem(icon: Icons.access_alarms, title: 'License'),
          ]),
        ],
        masterPane: masterMain(),
        detailPane: detailPane(),
        drawer: AppDrawer(
          defaultSmall: false,
          largeDrawerWidth: 200,
          largeDrawer: drawer(small: false),
          smallDrawerWidth: 60,
          smallDrawer: drawer(small: true),
        ),
        onBreakpointChange: () {
          setState(() {
            print('Breakpoint change');
          });
        },
        resizeBar: ResizeBar(
            leftColor: masterBackgroundColor,
            rightColor: detailBackgroundColor),
      ),
    );
  }

  Widget drawer({required bool small}) {
    return Container(
        color: Colors.greenAccent,
        child: ListView(
          children: [
            drawerButton(
              title: 'Users',
              icon: Icons.supervised_user_circle,
              small: small,
            ),
            drawerButton(
              title: 'Weighing',
              icon: Icons.add_road,
              small: small,
            ),
            drawerButton(
              title: 'Settings',
              icon: Icons.settings,
              small: small,
            ),
          ],
        ));
  }

  Widget drawerButton(
      {required String title, required IconData icon, required bool small}) {
    return small
        ? drawerSmallButton(icon: icon, title: title)
        : drawerLargeButton(icon: icon, title: title);
  }

  Widget drawerLargeButton({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 8,
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
            onTap: () {
              setState(() {
                _drawerIcon = icon;
                _drawerTitle = title;
              });
            },
          )),
    );
  }

  Widget drawerSmallButton({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
      child: Card(
          elevation: 8,
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _drawerIcon = icon;
                  _drawerTitle = title;
                });
              },
              child: Center(child: Icon(icon, size: 30, color: Colors.black54)),
            ),
          )),
    );
  }

  Builder detailPane() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: detailBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 12,
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                          child:
                              Text('DETAIL', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GridData(db: db),
                const SizedBox(height: 20),
                if (context.appScreen.isCompact())
                  ElevatedButton(
                    onPressed: () {
                      context.appScreen.showOnlyMaster();
                    },
                    child: const Text('Show master'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Builder masterPane() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: masterBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 12,
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                          child:
                              Text('MASTER', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.blueGrey[100]),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      context.appScreen.hideMenu();
                      context.appScreen.closeDrawer();
                      context.appScreen.showOnlyMaster();
                    },
                    child: const Text('Submit'),
                  ),
                ),
                if (context.appScreen.isCompact())
                  ElevatedButton(
                    onPressed: () {
                      context.appScreen.showOnlyDetail();
                    },
                    child: const Text('Show detail'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Builder masterForm() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: masterBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 12,
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Container(
                      color: Colors.greenAccent,
                      child: const Center(
                          child:
                              Text('MASTER', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                if (context.appScreen.isCompact())
                  ElevatedButton(
                    onPressed: () {
                      context.appScreen.showOnlyDetail();
                    },
                    child: const Text('Show detail'),
                  ),
                UserFormRegister(db: db),
              ],
            ),
          ),
        );
      },
    );
  }

  Builder masterWeighing() {
    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 2),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 12,
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Center(
                            child: Text('Add Weight',
                                style: TextStyle(fontSize: 20))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: WeighingForm(db: db)
                  ),
                  if (context.appScreen.isCompact())
                    ElevatedButton(
                      onPressed: () {
                        context.appScreen.showOnlyDetail();
                      },
                      child: const Text('Show detail'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Builder masterMain() {
    switch (screenSelected) {
      case 1:
        {
          return masterForm();
        }
        break;
      case 2:
        {
          return masterWeighing();
        }
        break;
      default:
        {
          return masterForm();
        }
        break;
    }
  }
}
*/

/*class CasTruckHomePage extends StatefulWidget {
  const CasTruckHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CasTruckHomePage> createState() => _CasTruckHomePageState();
}

class _CasTruckHomePageState extends State<CasTruckHomePage> {

  String dataWeight = "";
  var availablePorts = plugCom.availablePorts();
  late StreamSubscription streamSubscription;

  @override
  void initState() {
streamSubscription = plugCom.weightUpdates.listen((newVal)
    => setState(() {
      dataWeight = newVal;
    }));

    super.initState();
    initPlugCom();
  }

 void initPlugCom(){
    plugCom.configuration(plugCom.availablePorts().first);
    plugCom.runCapture();
  }

  void close(){
    plugCom.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Scrollbar(
        child: ListView(
          children: [

for (final address in availablePorts)
              Builder(builder: (context) {
                return ExpansionTile(
                  title: Text(address),

                  children: [
                    CardListTile(name: 'Description', value: plugCom.getInformation()['Description']),
                    CardListTile(name: 'Transport', value: plugCom.getInformation()['Transport']),
                    CardListTile(name: 'USB Bus', value: plugCom.getInformation()['USB Bus']),
                    CardListTile(name: 'USB Device', value: plugCom.getInformation()['USB Device']),
                    CardListTile(name: 'Vendor ID', value: plugCom.getInformation()['Vendor ID']),
                    CardListTile(name: 'Product ID', value: plugCom.getInformation()['Product ID']),
                    CardListTile(name: 'Manufacturer', value: plugCom.getInformation()['Manufacturer']),
                    CardListTile(name: 'Product Name', value: plugCom.getInformation()['Product Name']),
                    CardListTile(name: 'Serial Number', value: plugCom.getInformation()['Serial Number']),
                    CardListTile(name: 'MAC Address', value: plugCom.getInformation()['MAC Address']),
                    CardListTile(name: 'Output',  value:  dataWeight),

                  ],
                );
              }),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: close,
        tooltip: 'Close',
        child: const Icon(Icons.search),
      ),
    );
  }
}
class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile({Key? key, required this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}*/
