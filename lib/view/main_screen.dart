import 'dart:io';

import 'package:castruckmul/view/user_form_register.dart';
import 'package:castruckmul/view/weighing_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_menu/flutter_menu.dart';

import '../domain/get_data.dart';
import 'capture_weight_view.dart';
import 'grid_data.dart';
import 'grid_pending_weight.dart';

class MainScreen extends StatefulWidget{
  final GetDataUseCase db;
  const MainScreen({Key? key, required this.db}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  Color masterBackgroundColor = Colors.white;
  Color detailBackgroundColor = Colors.lightBlueAccent;
  IconData _drawerIcon = Icons.menu;
  String _drawerTitle = 'Tap a Item';
  int screenSelected = 2;

  @override
  void initState() {
    super.initState();
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
                detailMain();
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
                detailMain();
                setState(() {});
              },
            ),
            MenuListItem(
              icon: Icons.close,
              title: 'Close',
              onPressed: () {
                exit(0);
              },
            ),
          ]),
          MenuItem(title: 'Reports', isActive: true, menuListItems: [
            MenuListItem(
                icon: Icons.report,
                title: 'Report for date'
            ),
          ]),
          MenuItem(title: 'Help', isActive: true, menuListItems: [
            MenuListItem(
                icon: Icons.help,
                title: 'Help'
            ),
            MenuListItem(
                icon: Icons.question_answer,
                title: 'About'
            ),
            MenuListItem(
                icon: Icons.access_alarms,
                title: 'License'
            ),
          ]),
        ],
        masterPane: masterMain(),
        detailPane: detailMain(),
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
              if(title == 'Users'){
                screenSelected = 1;
                _drawerIcon = icon;
                _drawerTitle = title;
              }
              if(title == 'Weighing'){
                screenSelected = 2;
                _drawerIcon = icon;
                _drawerTitle = title;
              }
              if(title == 'Settings'){
                screenSelected = 3;
                _drawerIcon = icon;
                _drawerTitle = title;
              }
              //Navigator.popUntil(context, (route) => true);
              masterMain();
              detailMain();
              setState(() {});
              // setState(() {
              //   _drawerIcon = icon;
              //   _drawerTitle = title;
              // });
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
                if(title == 'Users'){
                  screenSelected = 1;
                  _drawerIcon = icon;
                  _drawerTitle = title;
                }
                if(title == 'Weighing'){
                  screenSelected = 2;
                  _drawerIcon = icon;
                  _drawerTitle = title;
                }
                if(title == 'Settings'){
                  screenSelected = 3;
                  _drawerIcon = icon;
                  _drawerTitle = title;
                }
                masterMain();
                detailMain();
                setState(() {});

                // setState(() {
                //   _drawerIcon = icon;
                //   _drawerTitle = title;
                // });
              },
              child: Center(child: Icon(icon, size: 30, color: Colors.black54)),
            ),
          )),
    );
  }


  Builder masterMain(){
    switch(screenSelected){
      case 1:
        {
          return masterUser();
        }
        break;
      case 2:
        {
          return masterWeighing();
        }
        break;
      case 3:
        {
          return masterEmpty();
        }
        break;
      default:
        {
          return masterEmpty();
        }
        break;
    }
  }

  Builder detailMain(){
    switch(screenSelected){
      case 1:
        {
          return detailUsers();
        }
        break;
      case 2:
        {
          return detailWeighing();
        }
        break;
      case 3:
        {
          return detailEmpty();
        }
        break;
      default:
        {
          return detailEmpty();
        }
        break;
    }
  }

  Builder masterUser() {
    return Builder(
      builder: (BuildContext context){
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
                          Text('Add User', style: TextStyle(fontSize: 20))),
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
                UserFormRegister(db: widget.db),
              ],

            ),

          ),
        );
      },
    );
  }

  Builder masterWeighing() {
    return Builder(
      builder: (BuildContext context){
        return Container(
        color: masterBackgroundColor,
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
                        Text('Add Weight', style: TextStyle(fontSize: 20))),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              WeighingForm(db: widget.db),
              if (context.appScreen.isCompact())
                ElevatedButton(
                  onPressed: () {
                    context.appScreen.showOnlyDetail();
                  },
                  child: const Text('Show detail'),
                ),
            ],
          ),
        );
      },
    );
  }

  Builder masterEmpty() {
    return Builder(
      builder: (BuildContext context){
        return Container(
          color: masterBackgroundColor,
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
                        Text('Add Weight', style: TextStyle(fontSize: 20))),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (context.appScreen.isCompact())
                ElevatedButton(
                  onPressed: () {
                    context.appScreen.showOnlyDetail();
                  },
                  child: const Text('Show detail'),
                ),
            ],
          ),
        );
      },
    );
  }

  Builder detailUsers() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: detailBackgroundColor,
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
                          Text('Detail', style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GridData(db: widget.db),
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
          );
      },
    );
  }

  Builder detailWeighing(){
    return Builder(
      builder: (BuildContext context){
        return Container(
          color: detailBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CaptureWeight(),
                Column(
                  children: [
                    Card(
                      elevation: 12,
                      margin: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 200,
                        child: Container(
                          color: Colors.white,
                          child: const Center(
                            child:
                            Text('Pending', style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GridPending(db: widget.db),
                  ],
                ),
              ]
          ),
        );
      }
    );
  }

  Builder detailEmpty(){
    return Builder(
        builder: (BuildContext context){
          return Container(
            color: detailBackgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CaptureWeight(),
                  Column(
                    children: [
                      Card(
                        elevation: 12,
                        margin: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 200,
                          child: Container(
                            color: Colors.white,
                            child: const Center(
                              child:
                              Text('Pending', style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          );
        }
    );
  }
}